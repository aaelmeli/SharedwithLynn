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
    [uxr]
        order = FIRST
        family = LAGRANGE
    []
    [uyr]
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
    [sigma_rr_xy]
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
    [sigma_ii_xy]
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
    [sigma_ri_xy]
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
    [sigma_ir_xy]
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
        displacements='uxr uyr'
        component = 0
        base_name = real
        volumetric_locking_correction=True #allow F-Bar correction to include incompressiblity
    []
    [sigma_rr_y]
        type = ADStressDivergenceTensors
        variable = uyr
        displacements='uxr uyr'
        component = 1
        base_name = real
        volumetric_locking_correction=True
    []
#2
    [sigma_ii_x]# (-ve) sigma_ii
        type = ADStressDivergenceTensors
        variable = uxr
        displacements='uxi uyi'
        component = 0
        base_name = imaginary
        volumetric_locking_correction=True
        negative_stress_divergence='true'
    []
    [sigma_ii_y]
        type = ADStressDivergenceTensors
        variable = uyr
        displacements='uxi uyi'
        component = 1
        base_name = imaginary
        volumetric_locking_correction=True
        negative_stress_divergence='true'
    []
#3
    [sigma_ri_x] #sigma_ri
    type = ADStressDivergenceTensors
    variable = uxi
    displacements='uxr uyr'
    component = 0
    base_name = real_imag
    volumetric_locking_correction=True 
    []   
    [sigma_ri_y]
    type = ADStressDivergenceTensors
    variable = uyi
    displacements='uxr uyr'
    component = 1
    base_name = real_imag
    volumetric_locking_correction=True
    []
#4
    [sigma_ir_x]#sigma_ir
    type = ADStressDivergenceTensors
    variable = uxi
    displacements='uxi uyi'
    component = 0
    base_name = imag_real
    volumetric_locking_correction=True
    []        
    [sigma_ir_y]
    type = ADStressDivergenceTensors
    variable = uyi
    displacements='uxi uyi'
    component = 1
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
[]
#push information, location and amplitudes-this is changable when we incorporate the fourier transformed push.
#in that case, we would need to loop over frequencies, load the force from csv, in a similar to what we have in the adjoint solve input.
[DiracKernels]
    [source_real_in_x1] 
        type = ConstantPointSource
        point = '0.015 0.024 0'
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
    [sigma_rr_xy]
        type = ADRankTwoAux
        rank_two_tensor = real_differentiated_stress
        variable = sigma_rr_xy
        index_i = 0
        index_j = 1
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
    [sigma_ri_xy]
        type = ADRankTwoAux
        rank_two_tensor = real_imag_differentiated_stress
        variable = sigma_ri_xy
        index_i = 0
        index_j = 1
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
    [sigma_ir_xy]
        type = ADRankTwoAux
        rank_two_tensor = imag_real_differentiated_stress
        variable = sigma_ir_xy
        index_i = 0
        index_j = 1
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
    [sigma_ii_xy]
        type = ADRankTwoAux
        rank_two_tensor = imaginary_differentiated_stress
        variable = sigma_ii_xy
        index_i = 0
        index_j = 1
    []     
[]

[Functions]
   [storage_modulus_dist1]
        type = ParsedFunction
        value = 'if((((x-0.015)^2)+((y-0.015)^2)) <= 0.000049,80,25)'
    []
    [storage_modulus_dist]
        type = PiecewiseMulticonstant
        data_file = storage_modulus_dist.txt #this holds the spatial distribution of the youngs_modulus
        direction = 'left left' #check this, it is also become available to define the centroid of the elements only.
    []
    [loss_modulus_dist1]
        type = ParsedFunction
        value = 'if((((x-0.015)^2)+((y-0.015)^2)) <= 0.000049,${fparse 80*(omega/omega_bar)} ,${fparse 25*(omega/omega_bar)})'
    []
    [loss_modulus_dist]
        type = PiecewiseMulticonstant
        data_file = loss_modulus_dist.txt #this holds the spatial distribution of the youngs_modulus
        direction = 'left left' #check this, it is also become available to define the centroid of the elements only.
    []  
[]

[BCs]
#Left
#pressure wave BCs
  [uxr_left_1]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = '3'
        v = uxi
        coef=${fparse omega*C_lr} 
  []
  [uxr_left_2]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = '3'
        v = uxr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch, (2 when nue=0, and 3 when nue =0.499)
  []
  [uxi_left_1]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = '3'
        v = uxi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [uxi_left_2]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = '3'
        v = uxr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
   [uyr_left_1]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = '3'
        v = uyi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyr_left_2]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = '3'
        v = uyr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_left_1]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = '3'
        v = uyi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_left_2]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = '3'
        v = uyr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
#bottom
#pressure wave BCs
  [uxr_bottom_1]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = '0'
        v = uyi
        coef=${fparse omega*C_lr} 
  []
  [uxr_bottom_2]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = '0'
        v = uyr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [uxi_bottom_1]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = '0'
        v = uyi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [uxi_bottom_2]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = '0'
        v = uyr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
   [uyr_bottom_1]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = '0'
        v = uxi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyr_bottom_2]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = '0'
        v = uxr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_bottom_1]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = '0'
        v = uxi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_bottom_2]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = '0'
        v = uxr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []
#Right
#pressure wave BCs
  [uxr_right_1]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = '1'
        v = uxi
        coef=${fparse omega*C_lr} 
  []
  [uxr_right_2]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = '1'
        v = uxr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [uxi_right_1]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = '1'
        v = uxi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [uxi_right_2]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = '1'
        v = uxr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
   [uyr_right_1]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = '1'
        v = uyi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyr_right_2]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = '1'
        v = uyr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_right_1]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = '1'
        v = uyi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_right_2]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = '1'
        v = uyr
        coef=${fparse -omega*C_sr} #how can I change this during the runtime of matlab wrapper.
  []

 
#Top
#pressure wave BCs
  [uxr_Top_1]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = '2'
        v = uyi
        coef=${fparse omega*C_lr} 
  []
  [uxr_Top_2]
        type = CoupledVarNeumannBC
        variable = uyr
        boundary = '2'
        v = uyr
        coef=${fparse -omega*C_li}   #this means that I am using the negative branch
  []
  [uxi_Top_1]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = '2'
        v = uyi
        coef=${fparse -omega*C_li} #this means that I am using the negative branch
  []
  [uxi_Top_2]
        type = CoupledVarNeumannBC
        variable = uyi
        boundary = '2'
        v = uyr
        coef=${fparse -omega*C_lr} #check the sign
  []
#shear wave BCs
   [uyr_Top_1]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = '2'
        v = uxi
        coef=${fparse omega*C_sr}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyr_Top_2]
        type = CoupledVarNeumannBC
        variable = uxr
        boundary = '2'
        v = uxr
        coef=${fparse -omega*C_si}  #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_Top_1]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = '2'
        v = uxi
        coef=${fparse -omega*C_si} #how can I change this during the runtime of matlab wrapper.
  []
  [uyi_Top_2]
        type = CoupledVarNeumannBC
        variable = uxi
        boundary = '2'
        v = uxr
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
        type = ADComputePlaneSmallStrain
        base_name = real
        displacements='uxr uyr'
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
        displacements='uxr uyr'
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
        displacements='uxi uyi'
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
        type = ADComputePlaneSmallStrain
        base_name = imaginary
        displacements='uxi uyi'
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
        type = ADComputePlaneSmallStrain
        base_name = real_differentiated
        displacements='uxr uyr'
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
        type = ADComputePlaneSmallStrain
        base_name = real_imag_differentiated
        displacements='uxr uyr'
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
        type = ADComputePlaneSmallStrain
        base_name = imag_real_differentiated
        displacements='uxi uyi'
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
        type = ADComputePlaneSmallStrain
        base_name = imaginary_differentiated
        displacements='uxi uyi'
    []
    [stress_imaginary_differentiated]
        type = ADComputeLinearElasticStress
        base_name = imaginary_differentiated
    []   
[]

[VectorPostprocessors]
    [uxr_point_sample]
        type = PointValueSampler
        variable = 'uxr'
        points = '0.015 0.015 0'
        sort_by = x
        outputs='u_all'
    []
    [uxi_point_sample]
        type = PointValueSampler
        variable = 'uxi'
        points = '0.015 0.015 0'
        sort_by = x
        outputs='u_all'
    []    
    [wavefield_real_x]
        type = NodalValueSampler #if not specified which id, this will return the whole reponse
        variable = 'uxr'
        sort_by = id
        execute_on=timestep_end
        outputs='u_all'
    []
    [wavefield_real_y]
        type = NodalValueSampler #if not specified which id, this will return the whole reponse
        variable = 'uyr'
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
    [wavefield_imaginary_y]
        type = NodalValueSampler #if not specified which id, this will return the whole reponse
        variable = 'uyi'
        sort_by = id
        execute_on=timestep_end
        outputs='u_all'
    []
    [wavefield_real_rcv]
        variable = 'uxr'
        type = LineValueSampler
        start_point = '0.015 0.0005 0'
        end_point = '0.015 0.022 0'
        num_points = 44
       sort_by = y
        execute_on=timestep_end
        output='u_all'
    []
    [wavefield_imag_rcv]
        variable = 'uxi'
        type = LineValueSampler
        start_point = '0.015 0.0005 0'
        end_point = '0.015 0.022 0'
        num_points = 44
        sort_by = y
        execute_on=timestep_end
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
