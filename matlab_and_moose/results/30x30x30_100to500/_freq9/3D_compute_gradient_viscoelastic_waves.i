#Here, to post process for gradient computation, we do not need to creat mesh, we can just reload the solution from the previouse solves.
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
    [dummy2] #dummy variable, we will not do any solve here, just multiplication, integration, and subtraction.
    []
    [dummy3] #dummy variable, we will not do any solve here, just multiplication, integration, and subtraction.
    []
[]

[AuxVariables]

    [dummy] #the variable that needed for ComputeVariableIsotropicElasticityTensor 
    []
    #load forward solution auxvariables (strains)
    #real strain aux variables
    #eps_rr
    [eps_rr_xx]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_rr_yy]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_rr_zz]
        order = CONSTANT
        family = MONOMIAL
    []    
    [eps_rr_xy]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_rr_xz]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_rr_yz]
        order = CONSTANT
        family = MONOMIAL
    []        
    #imaginary strain aux variables
    [eps_ii_xx]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_ii_yy]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_ii_zz]
        order = CONSTANT
        family = MONOMIAL
    []    
    [eps_ii_xy]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_ii_xz]
        order = CONSTANT
        family = MONOMIAL
    []
    [eps_ii_yz]
        order = CONSTANT
        family = MONOMIAL
    []        
    #adjoint solution auxvariables
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
    #gradient 
    [strain_stress]
        order = FIRST
        family = MONOMIAL
    []
    # variable to hold the integration of grad(v)*(grad(material w.r.t parameters))*grad(u)
    [integral_strain_stress]
         order = FIRST 
        family = MONOMIAL
    []              
[]
[Kernels]
    [urealx]
        type = StressDivergenceTensors
        variable = dummy2
        displacements='dummy2 dummy3 dummy3'
        component = 0
        base_name = real
        volumetric_locking_correction=True
    []
    [urealy]
        type = StressDivergenceTensors
        variable = dummy3
        displacements='dummy2 dummy3 dummy3'
        component = 1
        base_name = real
        volumetric_locking_correction=True
    []
[]
[AuxKernels]
    [load_eps_rr_xx]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_rr_xx
        variable = eps_rr_xx
        direct = true
    []
    [load_eps_rr_yy]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_rr_yy
        variable = eps_rr_yy
        direct = true
    []
    [load_eps_rr_zz]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_rr_zz
        variable = eps_rr_zz
        direct = true
    []    
    [load_eps_rr_xy]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_rr_xy
        variable = eps_rr_xy
        direct = true
    []
    [load_eps_rr_xz]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_rr_xz
        variable = eps_rr_xz
        direct = true
    []
     [load_eps_rr_yz]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_rr_yz
        variable = eps_rr_yz
        direct = true
    []       
    [load_eps_ii_xx]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_ii_xx
        variable = eps_ii_xx
        direct = true
    []
    [load_eps_ii_yy]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_ii_yy
        variable = eps_ii_yy
        direct = true
    []
    [load_eps_ii_zz]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_ii_zz
        variable = eps_ii_zz
        direct = true
    []    
    [load_eps_ii_xy]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_ii_xy
        variable = eps_ii_xy
        direct = true
    []
    [load_eps_ii_xz]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_ii_xz
        variable = eps_ii_xz
        direct = true
    []
    [load_eps_ii_yz]#used to reload the adjoint solution from old exudos file resulted from the adjoint solves
        type = SolutionAux
        solution = sln_eps_ii_yz
        variable = eps_ii_yz
        direct = true
    []        
    #load forward stresses
    [load_sigma_rr_xx]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_rr_xx
        variable = sigma_rr_xx
        direct = true
    []
    [load_sigma_rr_yy]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_rr_yy
        variable = sigma_rr_yy
        direct = true
    []
    [load_sigma_rr_zz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_rr_zz
        variable = sigma_rr_zz
        direct = true
    []    
    [load_sigma_rr_xy]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_rr_xy
        variable = sigma_rr_xy
        direct = true
    []
    [load_sigma_rr_xz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_rr_xz
        variable = sigma_rr_xz
        direct = true
    []
    [load_sigma_rr_yz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_rr_yz
        variable = sigma_rr_yz
        direct = true
    []        
    #sigma_ii
    [load_sigma_ii_xx]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ii_xx
        variable = sigma_ii_xx
        direct = true
    []
    [load_sigma_ii_yy]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ii_yy
        variable = sigma_ii_yy
        direct = true
    []
    [load_sigma_ii_zz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ii_zz
        variable = sigma_ii_zz
        direct = true
    []    
    [load_sigma_ii_xy]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ii_xy
        variable = sigma_ii_xy
        direct = true
    []
    [load_sigma_ii_xz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ii_xz
        variable = sigma_ii_xz
        direct = true
    []
    [load_sigma_ii_yz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ii_yz
        variable = sigma_ii_yz
        direct = true
    []        
    #sigma_ri
    [load_sigma_ri_xx]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ri_xx
        variable = sigma_ri_xx
        direct = true
    []
    [load_sigma_ri_yy]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ri_yy
        variable = sigma_ri_yy
        direct = true
    []
    [load_sigma_ri_zz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ri_zz
        variable = sigma_ri_zz
        direct = true
    []    
    [load_sigma_ri_xy]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ri_xy
        variable = sigma_ri_xy
        direct = true
    []
    [load_sigma_ri_xz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ri_xz
        variable = sigma_ri_xz
        direct = true
    []
    [load_sigma_ri_yz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ri_yz
        variable = sigma_ri_yz
        direct = true
    []    
    #sigma_ir
    [load_sigma_ir_xx]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ir_xx
        variable = sigma_ir_xx
        direct = true
    []
    [load_sigma_ir_yy]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ir_yy
        variable = sigma_ir_yy
        direct = true
    []
    [load_sigma_ir_zz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ir_zz
        variable = sigma_ir_zz
        direct = true
    []    
    [load_sigma_ir_xy]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ir_xy
        variable = sigma_ir_xy
        direct = true
    []
    [load_sigma_ir_xz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ir_xz
        variable = sigma_ir_xz
        direct = true
    []
    [load_sigma_ir_yz]#used to reload the forward solution from old exudos file resulted from the forward solves
        type = SolutionAux
        solution = sln_sigma_ir_yz
        variable = sigma_ir_yz
        direct = true
    []        
               
    [strain_stress_aux]
        type = ParsedAux
        args = 'eps_rr_xx  eps_ii_xx sigma_rr_xx sigma_ii_xx sigma_ri_xx sigma_ir_xx
                eps_rr_yy  eps_ii_yy sigma_rr_yy sigma_ii_yy sigma_ri_yy sigma_ir_yy
                eps_rr_zz  eps_ii_zz sigma_rr_zz sigma_ii_zz sigma_ri_zz sigma_ir_zz
                eps_rr_xy  eps_ii_xy sigma_rr_xy sigma_ii_xy sigma_ri_xy sigma_ir_xy
                eps_rr_xz  eps_ii_xz sigma_rr_xz sigma_ii_xz sigma_ri_xz sigma_ir_xz
                eps_rr_yz  eps_ii_yz sigma_rr_yz sigma_ii_yz sigma_ri_yz sigma_ir_yz' 
        variable = strain_stress
        function = 'eps_rr_xx*sigma_rr_xx - eps_rr_xx*sigma_ii_xx - eps_ii_xx*sigma_ri_xx - eps_ii_xx*sigma_ir_xx
                 +  eps_rr_yy*sigma_rr_yy - eps_rr_yy*sigma_ii_yy - eps_ii_yy*sigma_ri_yy - eps_ii_yy*sigma_ir_yy
                 +  eps_rr_zz*sigma_rr_zz - eps_rr_zz*sigma_ii_zz - eps_ii_zz*sigma_ri_zz - eps_ii_zz*sigma_ir_zz
                 +  2*eps_rr_xy*sigma_rr_xy - 2*eps_rr_xy*sigma_ii_xy - 2*eps_ii_xy*sigma_ri_xy - 2*eps_ii_xy*sigma_ir_xy
                 +  2*eps_rr_xz*sigma_rr_xz - 2*eps_rr_xz*sigma_ii_xz - 2*eps_ii_xz*sigma_ri_xz - 2*eps_ii_xz*sigma_ir_xz
                 +  2*eps_rr_yz*sigma_rr_yz - 2*eps_rr_yz*sigma_ii_yz - 2*eps_ii_yz*sigma_ri_yz - 2*eps_ii_yz*sigma_ir_yz' 
    []

    # Elemental Lp integration of strain x stress
    [elemental_integral_gradu_gradv]
        type = ElementLpNormAux
        p=1 # I have modified the code in the Auxkernel to not take the absolute value. this has to be fixed in more appropriate way (TODO)
        variable = integral_strain_stress
        coupled_variable = strain_stress
    []                              
[]
[UserObjects]
    #load the adjoint solutions
    [sln_eps_rr_xx]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_rr_xx
    []
    [sln_eps_rr_yy]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_rr_yy
    []
    [sln_eps_rr_zz]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_rr_zz
    []    
    [sln_eps_rr_xy]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_rr_xy
    []
    [sln_eps_rr_xz]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_rr_xz
    []
    [sln_eps_rr_yz]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_rr_yz
    []        
    [sln_eps_ii_xx]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_ii_xx
    []
    [sln_eps_ii_yy]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_ii_yy
    []
    [sln_eps_ii_zz]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_ii_zz
    []    
    [sln_eps_ii_xy]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_ii_xy
    []
    [sln_eps_ii_xz]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_ii_xz
    []
    [sln_eps_ii_yz]
      type = SolutionUserObject
      mesh = '_adjoint_viscoelastic_waves/adjointsolve.e'
      system_variables = eps_ii_yz
    []        
    #load stresses from the forward solve
    #sigma_rr
    [sln_sigma_rr_xx]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_rr_xx
    []
    [sln_sigma_rr_yy]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_rr_yy
    []
    [sln_sigma_rr_zz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_rr_zz
    []    
    [sln_sigma_rr_xy]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_rr_xy
    []
    [sln_sigma_rr_xz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_rr_xz
    []
    [sln_sigma_rr_yz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_rr_yz
    []        
    #sigma_ii
    [sln_sigma_ii_xx]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ii_xx
    []
    [sln_sigma_ii_yy]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ii_yy
    []
    [sln_sigma_ii_zz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ii_zz
    []
    [sln_sigma_ii_xy]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ii_xy
    []
    [sln_sigma_ii_xz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ii_xz
    []
    [sln_sigma_ii_yz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ii_yz
    []         
    #sigma_ri
    [sln_sigma_ri_xx]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ri_xx
    []
    [sln_sigma_ri_yy]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ri_yy
    []
    [sln_sigma_ri_zz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ri_zz
    []    
    [sln_sigma_ri_xy]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ri_xy
    []
    [sln_sigma_ri_xz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ri_xz
    []
    [sln_sigma_ri_yz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ri_yz
    []         
    #sigma_ir
    [sln_sigma_ir_xx]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ir_xx
    []
    [sln_sigma_ir_yy]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ir_yy
    []
    [sln_sigma_ir_zz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ir_zz
    []    
    [sln_sigma_ir_xy]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ir_xy
    []
    [sln_sigma_ir_xz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ir_xz
    [] 
    [sln_sigma_ir_yz]
      type = SolutionUserObject
      mesh = '_forward_viscoelastic_waves/forwardsolve.e'
      system_variables = sigma_ir_yz
    []                                             
[]

[Materials]
    [youngs_modulus]
        type = GenericFunctionMaterial
        prop_names = 'youngs_modulus'
        prop_values = 1
    []
    [poissons_ratio]
        type = GenericConstantMaterial
        prop_names  = 'poissons_ratio'
        prop_values = 0.499#for now, use constant poissons ratio
    []
    #material definition for uxi,uyi
    [elasticity_tensor_real]
        type = ComputeVariableIsotropicElasticityTensor
        args = dummy
        youngs_modulus = youngs_modulus
        poissons_ratio = poissons_ratio
        base_name = real
    []
    [strain_real]
        type = ComputePlaneSmallStrain
        displacements='dummy2 dummy3'
        base_name = real
    []
    [stress_real]
        type = ComputeLinearElasticStress
        base_name = real
    []                           
[]

[BCs]
 
[]

[VectorPostprocessors]
    #[element_value_sampler]
    #  type = ElementValueSampler
    #  variable = 'strain_stress'
    #  sort_by = id
    #  execute_on = 'final'
    #  outputs='element_integral'
    #[]
    [gradient]
      type = ElementValueSampler
      variable = 'integral_strain_stress'
      sort_by = id
      execute_on = 'final'
      outputs='element_integral_Lp_norm'
    []
[]

#[Postprocessors]
#    [grad0]
#        type = ElementIntegralVariablePostprocessor
#        variable = strain_stress
#        outputs ='gradient'
#        execute_on='FINAL'
#    []
#[]
[Problem]
solve=false
[]
[Executioner]
    type = Steady
    solve_type = 'LINEAR'
[]

[Outputs]
    #[exodus]
    #    file_base = 'grad_computation_viscoelastic_waves/grad_'
    #    type = Exodus
    #    execute_on = final
    #[]
    #[gradient]
    #    file_base = 'grad_computation_viscoelastic_waves/grad_'
    #    type = CSV
    #    execute_on = final
    #[]
    #[element_integral]
    #    file_base = 'grad_computation_viscoelastic_waves/grad_per_element'
    #    type = CSV
    #    execute_on = final
    #[]
    [element_integral_Lp_norm]
        file_base = 'grad_computation_viscoelastic_waves/'
        type = CSV
        execute_on = final
    []
[]