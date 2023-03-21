#frequency
freq=100
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
    type = GeneratedMesh
    dim = 2
    xmin=0
    xmax=0.03
    ymin=0
    ymax=0.03
    nx = 60
    ny=60
[]

[Variables]
    [vxr]
        order = FIRST
        family = LAGRANGE
    []
    [vyr]
        order = FIRST
        family = LAGRANGE
    []
    [vxi]
        order = FIRST
        family = LAGRANGE
    []
    [vyi]
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
#Note: I have only 2 different sets of strains becuase I have (real and imaginary strains). Unlike stresses, we have 4 sets of stresses. 
    #eps_rr
    [eps_rr_xx]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_rr_yy]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_rr_xy]
        order = CONSTANT
        family = MONOMIAL
    []
    #eps_ii
    [eps_ii_xx]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_ii_yy]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_ii_xy]
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
        variable = vxr
        displacements='vxr vyr'
        component = 0
        base_name = real
        volumetric_locking_correction=True #allow F-Bar correction to include incompressiblity
    []
    [sigma_rr_y]
        type = ADStressDivergenceTensors
        variable = vyr
        displacements='vxr vyr'
        component = 1
        base_name = real
        volumetric_locking_correction=True
    []
#2
    [sigma_ii_x]# (-ve) sigma_ii
        type = ADStressDivergenceTensors
        variable = vxr
        displacements='vxi vyi'
        component = 0
        base_name = imaginary
        volumetric_locking_correction=True
        negative_stress_divergence='true'
    []
    [sigma_ii_y]
        type = ADStressDivergenceTensors
        variable = vyr
        displacements='vxi vyi'
        component = 1
        base_name = imaginary
        volumetric_locking_correction=True
        negative_stress_divergence='true'
    []
#3
    [sigma_ri_x] #sigma_ri
    type = ADStressDivergenceTensors
    variable = vxi
    displacements='vxr vyr'
    component = 0
    base_name = real_imag
    volumetric_locking_correction=True 
    []   
    [sigma_ri_y]
    type = ADStressDivergenceTensors
    variable = vyi
    displacements='vxr vyr'
    component = 1
    base_name = real_imag
    volumetric_locking_correction=True
    []
#4
    [sigma_ir_x]#sigma_ir
    type = ADStressDivergenceTensors
    variable = vxi
    displacements='vxi vyi'
    component = 0
    base_name = imag_real
    volumetric_locking_correction=True
    []        
    [sigma_ir_y]
    type = ADStressDivergenceTensors
    variable = vyi
    displacements='vxi vyi'
    component = 1
    base_name = imag_real
    volumetric_locking_correction=True
    []   
#reaction terms
    [reaction_realx]
        type = Reaction
        variable = vxr
        rate = ${fparse -omega*omega} #how can I change this during the runtime of matlab wrapper.
    []
    [reaction_realy]
        type = Reaction
        variable = vyr
        rate = ${fparse -omega*omega} #how can I change this during the runtime of matlab wrapper.
    []
    [reaction_imagx]
        type = Reaction
        variable = vxi
        rate = ${fparse -omega*omega} #how can I change this during the runtime of matlab wrapper.
    []
    [reaction_imagy]
        type = Reaction
        variable = vyi
        rate = ${fparse -omega*omega} #how can I change this during the runtime of matlab wrapper.
    []
[]
#adjoint forces
[DiracKernels]
    [source_real_from_file] # dirac sources will be used to apply the misift as sources for the adjoint solves
        type = ReporterPointSource
        variable = vxr
        value_name = 'csv_real_reader/value'
        x_coord_name = csv_real_reader/x
        y_coord_name = csv_real_reader/y
        z_coord_name = csv_real_reader/z
    []
    [source_imaginary_from_file] # dirac sources will be used to apply the misift as sources for the adjoint solves
        type = ReporterPointSource
        variable = vxi
        value_name = 'csv_imag_reader/value'
        x_coord_name = csv_imag_reader/x
        y_coord_name = csv_imag_reader/y
        z_coord_name = csv_imag_reader/z
     []    
    #[source_real] # this is ok for manually appying point source
    #    type = ConstantPointSource
    #    point = '0.015 0.015 0'
    #    variable = vxr 
    #    value = -0.01162918962296700
    #[]
    #[source_imaginar] # this is ok for manually appying point source
    #     type = ConstantPointSource
    #    point = '0.015 0.015 0'
    #    variable = vxi 
    #    value = 0.03572543147833600
    #[]    
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
   #compute eps_rr. Note: the rank_two_tensor is after differentiating the elasticity tensor w.r.t the model parameter.Check the accuracy!!!
    [eps_rr_xx]
        type = ADRankTwoAux
        rank_two_tensor = real_mechanical_strain #check this
        variable = eps_rr_xx
        index_i = 0
        index_j = 0
    []
    [eps_rr_yy]
        type = ADRankTwoAux
        rank_two_tensor = real_mechanical_strain
        variable = eps_rr_yy
        index_i = 1
        index_j = 1
    []
    [eps_rr_xy]
        type = ADRankTwoAux
        rank_two_tensor = real_mechanical_strain
        variable = eps_rr_xy
        index_i = 0
        index_j = 1
    []
    #compute eps_ii.
    [eps_ii_xx]
        type = ADRankTwoAux
        rank_two_tensor = imaginary_mechanical_strain
        variable = eps_ii_xx
        index_i = 0
        index_j = 0
    []
    [eps_ii_yy]
        type = ADRankTwoAux
        rank_two_tensor = imaginary_mechanical_strain
        variable = eps_ii_yy
        index_i = 1
        index_j = 1
    []
    [eps_ii_xy]
        type = ADRankTwoAux
        rank_two_tensor = imaginary_mechanical_strain
        variable = eps_ii_xy
        index_i = 0
        index_j = 1
    []     
[]

[Functions]
    #[func_storage_modulus]
    #    type = ParsedFunction
    #    value = 'if((((x-0.015)^2)+((y-0.015)^2)) <= 0.000049,50,25)' #this can be frequency dependent ${fparse const1*omega}, ${fparse const2*omega/omega_bar}
    #    #value = ${young_mod}
    #    #value=9.9999
    #[]
    [storage_modulus_dist]
        type = PiecewiseMulticonstant
        data_file = storage_modulus_dist.txt #this holds the spatial distribution of the youngs_modulus
        direction = 'left left' #check this, it is also become available to define the centroid of the elements only.
    []
    #[func_loss_modulus1]
    #    type = ParsedFunction
    #    value = 'if((((x-0.015)^2)+((y-0.015)^2)) <= 0.000049,5,1)' #${fparse const1*omega/omega_bar}, ${fparse const2*omega/omega_bar}
    #    #value = ${young_mod}
    #    #value=0.99999
    #[]
    [loss_modulus_dist]
        type = PiecewiseMulticonstant
        data_file = loss_modulus_dist.txt #this holds the spatial distribution of the youngs_modulus
        direction = 'left left' #check this, it is also become available to define the centroid of the elements only.
    []  
[]


[BCs]
#Left
#pressure wave BCs
  [vxr_left_1]
        type = CoupledVarNeumannBC
        variable = vxr
        boundary = '3'
        v = vxi
        coef=${fparse omega*C_lr} 
  []
  [vxr_left_2]
        type = CoupledVarNeumannBC
        variable = vxr
        boundary = '3'
        v = vxr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch, (2 when nue=0, and 3 when nue =0.499)
  []
  [vxi_left_1]
        type = CoupledVarNeumannBC
        variable = vxi
        boundary = '3'
        v = vxi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [vxi_left_2]
        type = CoupledVarNeumannBC
        variable = vxi
        boundary = '3'
        v = vxr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
   [vyr_left_1]
        type = CoupledVarNeumannBC
        variable = vyr
        boundary = '3'
        v = vyi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [vyr_left_2]
        type = CoupledVarNeumannBC
        variable = vyr
        boundary = '3'
        v = vyr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [vyi_left_1]
        type = CoupledVarNeumannBC
        variable = vyi
        boundary = '3'
        v = vyi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [vyi_left_2]
        type = CoupledVarNeumannBC
        variable = vyi
        boundary = '3'
        v = vyr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
#bottom
#pressure wave BCs
  [vxr_bottom_1]
        type = CoupledVarNeumannBC
        variable = vyr
        boundary = '0'
        v = vyi
        coef=${fparse omega*C_lr} 
  []
  [vxr_bottom_2]
        type = CoupledVarNeumannBC
        variable = vyr
        boundary = '0'
        v = vyr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [vxi_bottom_1]
        type = CoupledVarNeumannBC
        variable = vyi
        boundary = '0'
        v = vyi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [vxi_bottom_2]
        type = CoupledVarNeumannBC
        variable = vyi
        boundary = '0'
        v = vyr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
   [vyr_bottom_1]
        type = CoupledVarNeumannBC
        variable = vxr
        boundary = '0'
        v = vxi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [vyr_bottom_2]
        type = CoupledVarNeumannBC
        variable = vxr
        boundary = '0'
        v = vxr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [vyi_bottom_1]
        type = CoupledVarNeumannBC
        variable = vxi
        boundary = '0'
        v = vxi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [vyi_bottom_2]
        type = CoupledVarNeumannBC
        variable = vxi
        boundary = '0'
        v = vxr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
#Right
#pressure wave BCs
  [vxr_right_1]
        type = CoupledVarNeumannBC
        variable = vxr
        boundary = '1'
        v = vxi
        coef=${fparse omega*C_lr} 
  []
  [vxr_right_2]
        type = CoupledVarNeumannBC
        variable = vxr
        boundary = '1'
        v = vxr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [vxi_right_1]
        type = CoupledVarNeumannBC
        variable = vxi
        boundary = '1'
        v = vxi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [vxi_right_2]
        type = CoupledVarNeumannBC
        variable = vxi
        boundary = '1'
        v = vxr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
   [vyr_right_1]
        type = CoupledVarNeumannBC
        variable = vyr
        boundary = '1'
        v = vyi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [vyr_right_2]
        type = CoupledVarNeumannBC
        variable = vyr
        boundary = '1'
        v = vyr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [vyi_right_1]
        type = CoupledVarNeumannBC
        variable = vyi
        boundary = '1'
        v = vyi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [vyi_right_2]
        type = CoupledVarNeumannBC
        variable = vyi
        boundary = '1'
        v = vyr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []

 
#Top
#pressure wave BCs
  [vxr_Top_1]
        type = CoupledVarNeumannBC
        variable = vyr
        boundary = '2'
        v = vyi
        coef=${fparse omega*C_lr} 
  []
  [vxr_Top_2]
        type = CoupledVarNeumannBC
        variable = vyr
        boundary = '2'
        v = vyr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [vxi_Top_1]
        type = CoupledVarNeumannBC
        variable = vyi
        boundary = '2'
        v = vyi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [vxi_Top_2]
        type = CoupledVarNeumannBC
        variable = vyi
        boundary = '2'
        v = vyr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
   [vyr_Top_1]
        type = CoupledVarNeumannBC
        variable = vxr
        boundary = '2'
        v = vxi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [vyr_Top_2]
        type = CoupledVarNeumannBC
        variable = vxr
        boundary = '2'
        v = vxr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [vyi_Top_1]
        type = CoupledVarNeumannBC
        variable = vxi
        boundary = '2'
        v = vxi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [vyi_Top_2]
        type = CoupledVarNeumannBC
        variable = vxi
        boundary = '2'
        v = vxr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
[]

[Materials]         
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
        type = ADComputePlaneSmallStrain
        base_name = real
        displacements='vxr vyr'
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
        type = ADComputePlaneSmallStrain
        base_name = real_imag
        displacements='vxr vyr'
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
        type = ADComputePlaneSmallStrain
        base_name = imag_real
        displacements='vxi vyi'
    []
    [stress_imag_real]
        type = ADComputeLinearElasticStress
        base_name = imag_real
    []
    #sigma_ii and eps_ii
    [elasticity_tensor_imaginary]
        type = ADComputeVariableIsotropicElasticityTensor
        #args = dummy
        base_name = imaginary
        youngs_modulus = loss_modulus
        poissons_ratio = poissons_ratio
    []
    [strain_imaginary]
        type = ADComputePlaneSmallStrain
        base_name = imaginary
        displacements='vxi vyi'
    []
    [stress_imaginary]
        type = ADComputeLinearElasticStress
        base_name = imaginary
    []  
[]

[VectorPostprocessors]
  [csv_real_reader]
    type = CSVReader
    csv_file = '_adjoint_viscoelastic_waves/adjoint_real_force.csv'
  []
  [csv_imag_reader]
    type = CSVReader
    csv_file = '_adjoint_viscoelastic_waves/adjoint_imag_force.csv'
  []        
[]


[Outputs]
    [exodus]
        file_base = '_adjoint_viscoelastic_waves/adjointsolve'
        type = Exodus
        execute_on = 'final'
    []
        #perf_graph = true
[]

[Executioner]
    type = Steady
    solve_type=LINEAR
    petsc_options_iname = ' -pc_type'
    petsc_options_value = 'lu'
    #l_max_its=1000
    #solve_type = 'LINEAR'
[]
