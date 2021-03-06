// ------------------------- TOGGLE SWITCH MODEL ------------------------- //


// Stan script containing the inducer exchange model for the Toggle Switch developed by L. Bandiera presented 
// in the paper "Information content analysis reveals desirable aspects of in vivo experiments of a synthetic circuit".
// The script is used to simulate the response of the model (ODEs) for a determined event based experimental profile



functions{
  
  // Function containing the ODEs to be used for the inference
  
  real[] Toogle_one(real t, real[] y, real[] p, real[] x_r, int[] x_i){
    // Inputs (stimuly) definition
    real u_IPTG = x_r[1];
    real u_aTc = x_r[2];
    
    // Parameters definition
    real k_IPTG = p[1];
    real k_aTc = p[2];
    real k_L_pm0 = p[3];
    real k_L_pm = p[4];
    real theta_T = p[5];
    real theta_aTc = p[6];
    real n_aTc = p[7];
    real n_T = p[8];
    real k_T_pm0 = p[9];
    real k_T_pm = p[10];
    real theta_L = p[11];
    real theta_IPTG = p[12];
    real n_IPTG = p[13];
    real n_L = p[14];
    
    // ODEs right-hand side
    // Order of equations(dInd_dt) follows as dIPTG/dt, daTc/dt, dLacI/dt and dTetR/dt
    real dInd_dt[4];
    
    dInd_dt[1] = k_IPTG*(x_r[1]-y[1])-0.0165*y[1];
    dInd_dt[2] = k_aTc*(x_r[2]-y[2])-0.0165*y[2];

    dInd_dt[3] = ((1/0.1386)*(k_L_pm0+(k_L_pm/(1+(y[4]/theta_T*1/(1+(y[2]/theta_aTc)^n_aTc))^n_T))))-0.0165*y[3];
    dInd_dt[4] = ((1/0.1386)*(k_T_pm0+(k_T_pm/(1+(y[3]/theta_L*1/(1+(y[1]/theta_IPTG)^n_IPTG))^n_L))))-0.0165*y[4];
    
    // RESULTS
    return dInd_dt;
  }
  
  // Function type vector containing the equations where the root needs to be calculated for the ODEs steady states
  vector SteadyState(vector init, vector p, real[] x_r, int[] x_i){
    
    vector[4] alpha;
    // Parameters definition
    real k_IPTG = p[1];
    real k_aTc = p[2];
    real k_L_pm0 = p[3];
    real k_L_pm = p[4];
    real theta_T = p[5];
    real theta_aTc = p[6];
    real n_aTc = p[7];
    real n_T = p[8];
    real k_T_pm0 = p[9];
    real k_T_pm = p[10];
    real theta_L = p[11];
    real theta_IPTG = p[12];
    real n_IPTG = p[13];
    real n_L = p[14];
    
    // ODEs steady state equations. Order of initial guesses init is u_IPTG, u_aTc, LacI-RFP, TetR-GFP.
    // Order of equations (alpha) follows as dIPTG/dt, daTc/dt, dLacI/dt and dTetR/dt
    alpha[1] = (k_IPTG*init[1])/(k_IPTG+0.0165);
    alpha[2] = (k_aTc*init[2])/(k_aTc+0.0165);
    alpha[3] = ((1/0.1386)*(k_L_pm0+(k_L_pm/(1+((init[4]/theta_T)*1/(1+(alpha[2]/theta_aTc)^n_aTc))^n_T))))/0.0165;
    alpha[4] = ((1/0.1386)*(k_T_pm0+(k_T_pm/(1+((init[3]/theta_L)*1/(1+(alpha[1]/theta_IPTG)^n_IPTG))^n_L))))/0.0165;
    
    // Results
    return alpha;
  }
  
  matrix solve_coupled_ode(real[] ts, real[] p, real[] x_r, int[] x_i, int[] sp, real[] inputs, real[] toni, real[] ivss, real[] pre){
    int maxtime = num_elements(ts); // Number of time points
    int Nsp = num_elements(sp); // Number of events switches
    int Nevents = num_elements(sp)-1; // Number of events
    int tonil = num_elements(toni); // Number of time points for the 24h incubation
    int Neq = 4; // Number of ODE equations
    
    real final[maxtime,Neq]; // Object to contain the ODE results
    real initialV[Neq]; // Initial value for the states
    int i; // Index for the inputs
    vector[4] y_al; // Vector that will include the solutio of the algebraic solution for the steady state of the model
    real ssv[tonil,Neq]; // Steady state results
    real y0[Neq]; // Initial values for the ODEs variables at the first event
    
    // Calculation of initial guesses
    
    // Calculation of initial guesses for steady state
    y_al = SteadyState(to_vector(ivss), to_vector(p), pre, x_i); 
    y0[1] = y_al[1];
    y0[2] = y_al[2];
    y0[3] = y_al[3];
    y0[4] = y_al[4];
    
    // ON incubation calculation for the steady state
    ssv = integrate_ode_rk45(Toogle_one, y0,0,toni,p,pre, x_i, 1e-9, 1e-9, 1e7); 
    y0 = ssv[tonil];
  
    
    initialV = y0;
    i = 1;
    
    for (q in 1:Nevents){
      int itp = sp[q];  // General way to extract the initial time points of each event
      int lts = num_elements(ts[(sp[q]+1):sp[q+1]+1]);  // General way to define the number of elements in each event series
      real input = inputs[q]; // General way to extract the input values
      real Tevent[lts] = ts[(sp[q]+1):sp[q+1]+1];  // General way to extract the times of each event
      real part1[lts,Neq]; // Partial results for each event
      
      if (q == 1){part1 = integrate_ode_rk45(Toogle_one, initialV,itp,ts[(sp[q]+1):sp[q+1]+1],p,to_array_1d(inputs[i:(i+1)]), x_i, 1e-9, 1e-9, 1e7);}
      else{part1 = integrate_ode_rk45(Toogle_one, initialV,(itp-1e-7),ts[(sp[q]+1):sp[q+1]+1],p,to_array_1d(inputs[i:(i+1)]), x_i, 1e-9, 1e-9, 1e7);}  
      
      initialV = part1[lts];
      i=i+2;
      
      // Introduction of the partial results into the final object
      for (y in (itp+1):(itp+lts)){
        
        final[(y),]=(part1)[(y-itp),];
      };
      
    };
    
    // Return ODE results as a matrix
    return(to_matrix(final));
  }
}
