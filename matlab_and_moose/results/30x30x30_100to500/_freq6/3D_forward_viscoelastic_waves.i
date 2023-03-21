#frequency
freq=360
#frequency
omega=${fparse 2*3.14159265359*freq}
#omega_bar
omega_bar=15000 #this is the const in: G_complex = G_eff *( 1 + i * omega/omega_bar), where G_eff is the parameter that we reconstruct, and "i=sqrt(-1)"
#boundary pressure wave speed info.
C_lr=5
C_li=0.25
#boundary shear wave speed info.
C_sr=2.89 #assuming the medium is incompressible G=E/3, nue=0.499
C_si=0.1442 #assuming the medium is incompressible G=E/3, nue=0.499
[Mesh]
    [ROI]
    type = GeneratedMeshGenerator
    dim = 3
    xmin=0
    xmax=0.03
    ymin=0
    ymax=0.03
    zmin=0
    zmax=0.03
    nx = 30
    ny=  30
    nz=  30
    []
    [receivers_plane]
    type = BoundingBoxNodeSetGenerator
    input = ROI
    new_boundary = 'rcv_points'
    top_right = '0.03 0.022 0.015'
    bottom_left = '0.0 0.0 0.015'
    []
[]

[Variables]
    [uxr]
        order = FIRST
        family = LAGRANGE
    []
    [uyr]
        order = FIRST
        family = LAGRANGE
    []
    [uzr]
        order = FIRST
        family = LAGRANGE
    []
    [uxi]
        order = FIRST
        family = LAGRANGE
    []
    [uyi]
        order = FIRST
        family = LAGRANGE
    []
    [uzi]
        order = FIRST
        family = LAGRANGE
    []    
[]

[AuxVariables]
    [youngs_modulus_dist_auxvariable]
        order = CONSTANT
        family = MONOMIAL
    []
    [youngs_loss_dist_auxvariable]
        order = CONSTANT
        family = MONOMIAL
    []    
    [hetero_storage_modulus_dist_auxvariable]
        order = CONSTANT
        family = MONOMIAL
    []
    [hetero_loss_modulus_dist_auxvariable]
        order = CONSTANT
        family = MONOMIAL
    []           

    [dummy] #the variable that needed for ComputeVariableIsotropicElasticityTensor 
    []
#Note: I have 4 different sets of stresses becuase I have (real and imaginary strains), (real and imaginary elasticity tensors)
    #sigma_rr
    [sigma_rr_xx]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_rr_yy]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_rr_zz]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_rr_xy]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_rr_xz]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_rr_yz]
        order = CONSTANT
        family = MONOMIAL
    []
    #sigma_ii
    [sigma_ii_xx]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ii_yy]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ii_zz]
        order = CONSTANT
        family = MONOMIAL
    []    
    [sigma_ii_xy]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ii_xz]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ii_yz]
        order = CONSTANT
        family = MONOMIAL
    []        
    #sigma_ri
    [sigma_ri_xx]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ri_yy]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ri_zz]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ri_xy]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ri_xz]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ri_yz]
        order = CONSTANT
        family = MONOMIAL
    []     
    #sigma_ir
    [sigma_ir_xx]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ir_yy]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ir_zz]
        order = CONSTANT
        family = MONOMIAL
    []    
    [sigma_ir_xy]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ir_xz]
        order = CONSTANT
        family = MONOMIAL
    []
    [sigma_ir_yz]
        order = CONSTANT
        family = MONOMIAL
    []              

    [dummy] #the variable that needed for ComputeVariableIsotropicElasticityTensor 
    []
[]
[Kernels]
#1
    [sigma_rr_x]#kernels required for sigma_rr
        type = ADStressDivergenceTensors
        variable = uxr
        displacements='uxr uyr uzr'
        component = 0
        base_name = real
        volumetric_locking_correction=True #allow F-Bar correction to include incompressiblity
    []
    [sigma_rr_y]
        type = ADStressDivergenceTensors
        variable = uyr
        displacements='uxr uyr uzr'
        component = 1
        base_name = real
        volumetric_locking_correction=True
    []
    [sigma_rr_z]
        type = ADStressDivergenceTensors
        variable = uzr
        displacements='uxr uyr uzr'
        component = 2
        base_name = real
        volumetric_locking_correction=True
    []    
#2
    [sigma_ii_x]# (-ve) sigma_ii
        type = ADStressDivergenceTensors
        variable = uxr
        displacements='uxi uyi uzi'
        component = 0
        base_name = imaginary
        volumetric_locking_correction=True
        negative_stress_divergence='true'
    []
    [sigma_ii_y]
        type = ADStressDivergenceTensors
        variable = uyr
        displacements='uxi uyi uzi'
        component = 1
        base_name = imaginary
        volumetric_locking_correction=True
        negative_stress_divergence='true'
    []
    [sigma_ii_z]
        type = ADStressDivergenceTensors
        variable = uzr
        displacements='uxi uyi uzi'
        component = 2
        base_name = imaginary
        volumetric_locking_correction=True
        negative_stress_divergence='true'
    []    
#3
    [sigma_ri_x] #sigma_ri
    type = ADStressDivergenceTensors
    variable = uxi
    displacements='uxr uyr uzr'
    component = 0
    base_name = real_imag
    volumetric_locking_correction=True 
    []   
    [sigma_ri_y]
    type = ADStressDivergenceTensors
    variable = uyi
    displacements='uxr uyr uzr'
    component = 1
    base_name = real_imag
    volumetric_locking_correction=True
    []
    [sigma_ri_z]
    type = ADStressDivergenceTensors
    variable = uzi
    displacements='uxr uyr uzr'
    component = 2
    base_name = real_imag
    volumetric_locking_correction=True
    []    
#4
    [sigma_ir_x]#sigma_ir
    type = ADStressDivergenceTensors
    variable = uxi
    displacements='uxi uyi uzi'
    component = 0
    base_name = imag_real
    volumetric_locking_correction=True
    []        
    [sigma_ir_y]
    type = ADStressDivergenceTensors
    variable = uyi
    displacements='uxi uyi uzi'
    component = 1
    base_name = imag_real
    volumetric_locking_correction=True
    []
    [sigma_ir_z]
    type = ADStressDivergenceTensors
    variable = uzi
    displacements='uxi uyi uzi'
    component = 2
    base_name = imag_real
    volumetric_locking_correction=True
    []        
#reaction terms
    [reaction_realx]
        type = Reaction
        variable = uxr
        rate = ${fparse -omega*omega} #how can I change this during the runtime of matlab wrapper.
    []
    [reaction_realy]
        type = Reaction
        variable = uyr
        rate = ${fparse -omega*omega} #how can I change this during the runtime of matlab wrapper.
    []
    [reaction_realz]
        type = Reaction
        variable = uzr
        rate = ${fparse -omega*omega} #how can I change this during the runtime of matlab wrapper.
    []    
    [reaction_imagx]
        type = Reaction
        variable = uxi
        rate = ${fparse -omega*omega} #how can I change this during the runtime of matlab wrapper.
    []
    [reaction_imagy]
        type = Reaction
        variable = uyi
        rate = ${fparse -omega*omega} #how can I change this during the runtime of matlab wrapper.
    []
    [reaction_imagz]
        type = Reaction
        variable = uzi
        rate = ${fparse -omega*omega} #how can I change this during the runtime of matlab wrapper.
    []    
[]
#push information, location and amplitudes-this is changable when we incorporate the fourier transformed push.
#in that case, we would need to loop over frequencies, load the force from csv, in a similar to what we have in the adjoint solve input.
[DiracKernels]
    [source_real_in_x1] 
        type = ConstantPointSource
        point = '0.015 0.024 0.015'
        variable = uxr 
        value = 10
    []
[]

[AuxKernels]
    [storage_modulus_dist_auxkernel]
        type = FunctionAux #check this, this is working if the function is ParsedFunction, now I am using PiecewiseMulticonstant with mode = nearest
        function =  storage_modulus_dist
        variable = hetero_storage_modulus_dist_auxvariable
        execute_on = initial
    []
    #[hetero_storage_modulus_dist_auxkernel]
    #    type = FunctionAux #check this, this is working if the function is ParsedFunction, now I am using PiecewiseMulticonstant with mode = nearest
    #    function =  func_storage_modulus
    #    variable = hetero_storage_modulus_dist_auxvariable
    #    execute_on = initial
    #[]
    [loss_modulus_dist_auxkernel]
        type = FunctionAux #check this, this is working if the function is ParsedFunction, now I am using PiecewiseMulticonstant with mode = nearest
        function =  loss_modulus_dist
        variable = hetero_loss_modulus_dist_auxvariable
        execute_on = initial
    []
    #[hetero_loss_modulus_dist_auxkernel]
    #    type = FunctionAux #check this, this is working if the function is ParsedFunction, now I am using PiecewiseMulticonstant with mode = nearest
    #    function =  func_loss_modulus
    #    variable = hetero_loss_modulus_dist_auxvariable
    #    execute_on = initial
    #[]   
   #compute sigma_rr. Note: the rank_two_tensor is after differentiating the elasticity tensor w.r.t the model parameter.Check the accuracy!!!
    [sigma_rr_xx]
        type = ADRankTwoAux
        rank_two_tensor = real_differentiated_stress #check this
        variable = sigma_rr_xx
        index_i = 0
        index_j = 0
    []
    [sigma_rr_yy]
        type = ADRankTwoAux
        rank_two_tensor = real_differentiated_stress
        variable = sigma_rr_yy
        index_i = 1
        index_j = 1
    []
    [sigma_rr_zz]
        type = ADRankTwoAux
        rank_two_tensor = real_differentiated_stress
        variable = sigma_rr_zz
        index_i = 2
        index_j = 2
    []    
    [sigma_rr_xy]
        type = ADRankTwoAux
        rank_two_tensor = real_differentiated_stress
        variable = sigma_rr_xy
        index_i = 0
        index_j = 1
    []
    [sigma_rr_xz]
        type = ADRankTwoAux
        rank_two_tensor = real_differentiated_stress
        variable = sigma_rr_xz
        index_i = 0
        index_j = 2
    []
    [sigma_rr_yz]
        type = ADRankTwoAux
        rank_two_tensor = real_differentiated_stress
        variable = sigma_rr_yz
        index_i = 1
        index_j = 2
    []        
    #compute sigma_ri
    [sigma_ri_xx]
        type = ADRankTwoAux
        rank_two_tensor = real_imag_differentiated_stress #check this
        variable = sigma_ri_xx
        index_i = 0
        index_j = 0
    []
    [sigma_ri_yy]
        type = ADRankTwoAux
        rank_two_tensor = real_imag_differentiated_stress
        variable = sigma_ri_yy
        index_i = 1
        index_j = 1
    []
    [sigma_ri_zz]
        type = ADRankTwoAux
        rank_two_tensor = real_imag_differentiated_stress
        variable = sigma_ri_zz
        index_i = 2
        index_j = 2
    []    
    [sigma_ri_xy]
        type = ADRankTwoAux
        rank_two_tensor = real_imag_differentiated_stress
        variable = sigma_ri_xy
        index_i = 0
        index_j = 1
    []
    [sigma_ri_xz]
        type = ADRankTwoAux
        rank_two_tensor = real_imag_differentiated_stress
        variable = sigma_ri_xz
        index_i = 0
        index_j = 2
    []
    [sigma_ri_yz]
        type = ADRankTwoAux
        rank_two_tensor = real_imag_differentiated_stress
        variable = sigma_ri_yz
        index_i = 1
        index_j = 2
    []        
    #compute sigma_ir
    [sigma_ir_xx]
        type = ADRankTwoAux
        rank_two_tensor = imag_real_differentiated_stress #check this
        variable = sigma_ir_xx
        index_i = 0
        index_j = 0
    []
    [sigma_ir_yy]
        type = ADRankTwoAux
        rank_two_tensor = imag_real_differentiated_stress
        variable = sigma_ir_yy
        index_i = 1
        index_j = 1
    []
    [sigma_ir_zz]
        type = ADRankTwoAux
        rank_two_tensor = imag_real_differentiated_stress
        variable = sigma_ir_zz
        index_i = 2
        index_j = 2
    []    
    [sigma_ir_xy]
        type = ADRankTwoAux
        rank_two_tensor = imag_real_differentiated_stress
        variable = sigma_ir_xy
        index_i = 0
        index_j = 1
    []
    [sigma_ir_xz]
        type = ADRankTwoAux
        rank_two_tensor = imag_real_differentiated_stress
        variable = sigma_ir_xz
        index_i = 0
        index_j = 2
    []
    [sigma_ir_yz]
        type = ADRankTwoAux
        rank_two_tensor = imag_real_differentiated_stress
        variable = sigma_ir_yz
        index_i = 1
        index_j = 2
    []        
    #compute sigma_ii.
    [sigma_ii_xx]
        type = ADRankTwoAux
        rank_two_tensor = imaginary_differentiated_stress
        variable = sigma_ii_xx
        index_i = 0
        index_j = 0
    []
    [sigma_ii_yy]
        type = ADRankTwoAux
        rank_two_tensor = imaginary_differentiated_stress
        variable = sigma_ii_yy
        index_i = 1
        index_j = 1
    []
    [sigma_ii_zz]
        type = ADRankTwoAux
        rank_two_tensor = imaginary_differentiated_stress
        variable = sigma_ii_zz
        index_i = 2
        index_j = 2
    []    
    [sigma_ii_xy]
        type = ADRankTwoAux
        rank_two_tensor = imaginary_differentiated_stress
        variable = sigma_ii_xy
        index_i = 0
        index_j = 1
    []
    [sigma_ii_xz]
        type = ADRankTwoAux
        rank_two_tensor = imaginary_differentiated_stress
        variable = sigma_ii_xz
        index_i = 0
        index_j = 2
    []
    [sigma_ii_yz]
        type = ADRankTwoAux
        rank_two_tensor = imaginary_differentiated_stress
        variable = sigma_ii_yz
        index_i = 1
        index_j = 2
    []                 
[]

[Functions]
   [storage_modulus_dist1]
        type = ParsedFunction
        value = 'if((((x-0.015)^2)+((y-0.015)^2)+((z-0.015)^2)) <= 0.000049,80,25)'
    []
    [storage_modulus_dist]
        type = PiecewiseMulticonstant
        data_file = storage_modulus_dist.txt #this holds the spatial distribution of the youngs_modulus
        direction = 'left left left' #check this, it is also become available to define the centroid of the elements only.
    []
    [loss_modulus_dist1]
        type = ParsedFunction
        value = 'if((((x-0.015)^2)+((y-0.015)^2)+((z-0.015)^2)) <= 0.000049,${fparse 80*(omega/omega_bar)} ,${fparse 25*(omega/omega_bar)})'
    []
    [loss_modulus_dist]
        type = PiecewiseMulticonstant
        data_file = loss_modulus_dist.txt #this holds the spatial distribution of the youngs_modulus
        direction = 'left left left' #check this, it is also become available to define the centroid of the elements only.
    []  
[]

[BCs]
#Left
#pressure wave BCs
  [uxr_left_1]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'left'
        v = uxi
        coef=${fparse omega*C_lr} 
  []
  [uxr_left_2]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'left'
        v = uxr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch, (2 when nue=0, and 3 when nue =0.499)
  []
  [uxi_left_1]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'left'
        v = uxi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [uxi_left_2]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'left'
        v = uxr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
    #shear in y
   [uyr_left_1]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'left'
        v = uyi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyr_left_2]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'left'
        v = uyr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_left_1]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'left'
        v = uyi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_left_2]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'left'
        v = uyr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
  ##shear in z
    [uzr_left_1]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'left'
        v = uzi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uzr_left_2]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'left'
        v = uzr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uzi_left_1]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'left'
        v = uzi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uzi_left_2]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'left'
        v = uzr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
#bottom
#pressure wave BCs
  [uyr_bottom_1]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'bottom'
        v = uyi
        coef=${fparse omega*C_lr} 
  []
  [uyr_bottom_2]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'bottom'
        v = uyr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [uyi_bottom_1]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'bottom'
        v = uyi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [uyi_bottom_2]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'bottom'
        v = uyr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
#shear in x
   [uxr_bottom_1]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'bottom'
        v = uxi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uxr_bottom_2]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'bottom'
        v = uxr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uxi_bottom_1]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'bottom'
        v = uxi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uxi_bottom_2]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'bottom'
        v = uxr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
  #shear in z
  [uzr_bottom_1]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'bottom'
        v = uzi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uzr_bottom_2]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'bottom'
        v = uzr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uzi_bottom_1]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'bottom'
        v = uzi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uzi_bottom_2]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'bottom'
        v = uzr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
#Right
#pressure wave BCs
  [uxr_right_1]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'right'
        v = uxi
        coef=${fparse omega*C_lr} 
  []
  [uxr_right_2]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'right'
        v = uxr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [uxi_right_1]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'right'
        v = uxi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [uxi_right_2]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'right'
        v = uxr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
#shear in y
   [uyr_right_1]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'right'
        v = uyi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyr_right_2]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'right'
        v = uyr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_right_1]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'right'
        v = uyi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_right_2]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'right'
        v = uyr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
  #shear in z
  [uzr_right_1]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'right'
        v = uzi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uzr_right_2]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'right'
        v = uzr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uzi_right_1]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'right'
        v = uzi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uzi_right_2]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'right'
        v = uzr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
 
#Top
#pressure wave BCs
  [uyr_Top_1]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'top'
        v = uyi
        coef=${fparse omega*C_lr} 
  []
  [uyr_Top_2]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'top'
        v = uyr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [uyi_Top_1]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'top'
        v = uyi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [uyi_Top_2]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'top'
        v = uyr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
#shea in x
   [uxr_Top_1]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'top'
        v = uxi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uxr_Top_2]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'top'
        v = uxr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uxi_Top_1]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'top'
        v = uxi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uxi_Top_2]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'top'
        v = uxr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
  #shear in z
  [uzr_top_1]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'top'
        v = uzi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uzr_top_2]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'top'
        v = uzr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uzi_top_1]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'top'
        v = uzi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uzi_top_2]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'top'
        v = uzr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
#back
#pressure wave BCs
  [uzr_back_1]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'back'
        v = uzi
        coef=${fparse omega*C_lr} 
  []
  [uzr_back_2]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'back'
        v = uzr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [uzi_back_1]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'back'
        v = uzi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [uzi_back_2]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'back'
        v = uzr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
#shea in x
   [uxr_back_1]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'back'
        v = uxi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uxr_back_2]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'back'
        v = uxr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uxi_back_1]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'back'
        v = uxi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uxi_back_2]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'back'
        v = uxr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
  #shear in z
  [uyr_back_1]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'back'
        v = uyi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyr_back_2]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'back'
        v = uyr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_back_1]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'back'
        v = uyi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_back_2]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'back'
        v = uyr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
#front
#pressure wave BCs
  [uzr_front_1]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'front'
        v = uzi
        coef=${fparse omega*C_lr} 
  []
  [uzr_front_2]
        type = CoupledVarNeumannBC
        variable = uzr
        boundary = 'front'
        v = uzr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [uzi_front_1]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'front'
        v = uzi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [uzi_front_2]
        type = CoupledVarNeumannBC
        variable = uzi
        boundary = 'front'
        v = uzr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
#shea in x
   [uxr_front_1]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'front'
        v = uxi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uxr_front_2]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = 'front'
        v = uxr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uxi_front_1]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'front'
        v = uxi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uxi_front_2]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = 'front'
        v = uxr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
  #shear in z
  [uyr_front_1]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'front'
        v = uyi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyr_front_2]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = 'front'
        v = uyr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_front_1]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'front'
        v = uyi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_front_2]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = 'front'
        v = uyr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []         
[]


[Materials]
    [storage_modulus_differentiated]
        type = ADGenericFunctionMaterial
        prop_names = 'storage_modulus_differentiated'
        prop_values = 1
    []
    [loss_modulus_differentiated]
        type = ADGenericFunctionMaterial
        prop_names = 'loss_modulus_differentiated'
        prop_values = ${fparse omega/omega_bar}
        #prop_values= 0.1
    []            
    [storage_modulus]
        type = ADGenericFunctionMaterial
        prop_names = 'storage_modulus'
        prop_values = storage_modulus_dist
        #prop_values = func_storage_modulus #here, we consider the youngs modulus as the storage modulus. We can also define the shear modulus directly
    []
    [loss_modulus]
        type = ADGenericFunctionMaterial
        prop_names = 'loss_modulus'
        prop_values = loss_modulus_dist
        #prop_values = func_loss_modulus #here, we consider the youngs modulus as the loss modulus. We can also define the shear modulus directly
    []
    [poissons_ratio]
        type = ADGenericConstantMaterial
        prop_names  = 'poissons_ratio'
        prop_values = 0.499 #for now, use constant poissons ratio
    []

    #sigma_rr and eps_rr
    [elasticity_tensor_real]
        type = ADComputeVariableIsotropicElasticityTensor
        #args = dummy
        base_name = real
        youngs_modulus = 'storage_modulus'
        poissons_ratio = 'poissons_ratio'
    []
    [strain_real]
        type = ADComputeSmallStrain
        base_name = real
        displacements='uxr uyr uzr'
    []
    [stress_real]
        type = ADComputeLinearElasticStress
        base_name = real
    []
    #sigma_ri
    [elasticity_tensor_real_imag]
        type = ADComputeVariableIsotropicElasticityTensor
        #args = dummy
        base_name = real_imag
        youngs_modulus = loss_modulus
        poissons_ratio = poissons_ratio
    []
    [strain_real_imag]
        type = ADComputeSmallStrain
        base_name = real_imag
        displacements='uxr uyr uzr'
    []
    [stress_real_imag]
        type = ADComputeLinearElasticStress
        base_name = real_imag
    []
    #sigma_ir
    [elasticity_tensor_imag_real]
        type = ADComputeVariableIsotropicElasticityTensor
        #args = dummy
        base_name = imag_real
        youngs_modulus = storage_modulus
        poissons_ratio = poissons_ratio
    []
    [strain_imag_real]
        type = ADComputeSmallStrain
        base_name = imag_real
        displacements='uxi uyi uzi'
    []
    [stress_imag_real]
        type = ADComputeLinearElasticStress
        base_name = imag_real
    []
    #sigma_ii
    [elasticity_tensor_imaginary]
        type = ADComputeVariableIsotropicElasticityTensor
        #args = dummy
        base_name = imaginary
        youngs_modulus = loss_modulus
        poissons_ratio = poissons_ratio
    []
    [strain_imaginary]
        type = ADComputeSmallStrain
        base_name = imaginary
        displacements='uxi uyi uzi'
    []
    [stress_imaginary]
        type = ADComputeLinearElasticStress
        base_name = imaginary
    []

    #material used to compute the stresses after differentiating the elasticity tensor w.r.t the model parameter, here E. i.e put E=1
 
    #sigma_rr and eps_rr
    [elasticity_tensor_real_differentiated]
        type = ADComputeVariableIsotropicElasticityTensor
        #args = dummy
        base_name = real_differentiated
        youngs_modulus = 'storage_modulus_differentiated'
        poissons_ratio = 'poissons_ratio'
    []
    [strain_real_differentiated]
        type = ADComputeSmallStrain
        base_name = real_differentiated
        displacements='uxr uyr uzr'
    []
    [stress_real_differentiated]
        type = ADComputeLinearElasticStress
        base_name = real_differentiated
    []

    #sigma_ri
    [elasticity_tensor_real_imag_differentiated]
        type = ADComputeVariableIsotropicElasticityTensor
        #args = dummy
        base_name = real_imag_differentiated
        youngs_modulus = loss_modulus_differentiated
        poissons_ratio = poissons_ratio
    []
    [strain_real_imag_differentiated]
        type = ADComputeSmallStrain
        base_name = real_imag_differentiated
        displacements='uxr uyr uzr'
    []
    [stress_real_imag_differentiated]
        type = ADComputeLinearElasticStress
        base_name = real_imag_differentiated
    []

    #sigma_ir
    [elasticity_tensor_imag_real_differentiated]
        type = ADComputeVariableIsotropicElasticityTensor
        #args = dummy
        base_name = imag_real_differentiated
        youngs_modulus = 'storage_modulus_differentiated'
        poissons_ratio = poissons_ratio
    []
    [strain_imag_real_differentiated]
        type = ADComputeSmallStrain
        base_name = imag_real_differentiated
        displacements='uxi uyi uzi'
    []
    [stress_imag_real_differentiated]
        type = ADComputeLinearElasticStress
        base_name = imag_real_differentiated
    []

    #sigma_ii
    [elasticity_tensor_imaginary_differentiated]
        type = ADComputeVariableIsotropicElasticityTensor
        #args = dummy
        base_name = imaginary_differentiated
        youngs_modulus = loss_modulus_differentiated
        poissons_ratio = poissons_ratio
    []
    [strain_imaginary_differentiated]
        type = ADComputeSmallStrain
        base_name = imaginary_differentiated
        displacements='uxi uyi uzi'
    []
    [stress_imaginary_differentiated]
        type = ADComputeLinearElasticStress
        base_name = imaginary_differentiated
    []   
[]

[VectorPostprocessors]
    [wavefield_real_rcv1]
        variable = 'uxr'
        type = LineValueSampler
        start_point = '0.015 0.001 0'
        end_point = '0.015 0.022 0'
        num_points = 22
        sort_by = 'y'
        execute_on=timestep_end
        #output='u_all'
    []
    [wavefield_imag_rcv1]
        variable = 'uxi'
        type = LineValueSampler
        start_point = '0.015 0.001 0'
        end_point = '0.015 0.022 0'
        num_points = 22
        sort_by = 'y'
        execute_on=timestep_end
        #output='u_all'
    []
    [wavefield_real_x]
        type = NodalValueSampler #if not specified which id, this will return the whole reponse
        variable = 'uxr'
        sort_by = id
        execute_on=timestep_end
        outputs='u_all'
    []
    [wavefield_imaginary_x]
        type = NodalValueSampler #if not specified which id, this will return the whole reponse
        variable = 'uxi'
        sort_by = id
        execute_on=timestep_end
        outputs='u_all'
    []
      [wavefield_real_rcv]
            type = NodalValueSampler
            variable = uxr
            boundary = 'rcv_points'
            sort_by = id
            output='u_all'
      []
      [wavefield_imag_rcv]
            type = NodalValueSampler
            variable = uxi
            boundary = 'rcv_points'
            sort_by = id
            output='u_all'
      []                                  
[]


# Note: This output block is out of its normal place (should be at the bottom)
[Outputs]
    [exodus]
        file_base = '_forward_viscoelastic_waves/forwardsolve'
        type = Exodus
        execute_on = final
    []
    [u_all]
        file_base = '_forward_viscoelastic_waves/'
        type = CSV
        execute_vector_postprocessors_on = 'final'
    []
        #perf_graph = true
[]

# Note: The executioner is out of its normal place (should be just about the output block)
[Executioner]
    type = Steady
    solve_type=LINEAR
    petsc_options_iname = ' -pc_type'
    petsc_options_value = 'lu'
    #l_max_its=1000
    #solve_type = 'LINEAR'
[]
