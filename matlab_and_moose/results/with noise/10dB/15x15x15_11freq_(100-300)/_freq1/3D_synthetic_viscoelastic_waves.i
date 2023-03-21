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
    nx = 15
    ny=  15
    nz=  15
    []
    [receivers_plane]
    type = BoundingBoxNodeSetGenerator
    input = ROI
    new_boundary = 'rcv_points'
    top_right = '0.03 0.02 0.016'
    bottom_left = '0.0 0.0 0.016'
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

[DiracKernels]
    [source_real_in_x1] 
        type = ConstantPointSource
        point = '0.014 0.024 0.014'
        variable = uxr 
        value = 10
    []
[]
[AuxKernels]
    #[storage_modulus_dist_auxkernel]
    #    type = FunctionAux #check this, this is working if the function is ParsedFunction, now I am using PiecewiseMulticonstant with mode = nearest
    #    function =  storage_modulus_dist
    #    variable = storage_modulus_dist_auxvariable
    #    execute_on = initial
    #[]
    [hetero_storage_modulus_dist_auxkernel]
        type = FunctionAux #check this, this is working if the function is ParsedFunction, now I am using PiecewiseMulticonstant with mode = nearest
        function =  storage_modulus_dist
        variable = hetero_storage_modulus_dist_auxvariable
        execute_on = initial
    []
    #[loss_modulus_dist_auxkernel]
    #    type = FunctionAux #check this, this is working if the function is ParsedFunction, now I am using PiecewiseMulticonstant with mode = nearest
    #    function =  loss_modulus_dist
    #    variable = loss_modulus_dist_auxvariable
    #    execute_on = initial
    #[]
    [hetero_loss_modulus_dist_auxkernel]
        type = FunctionAux #check this, this is working if the function is ParsedFunction, now I am using PiecewiseMulticonstant with mode = nearest
        function =  loss_modulus_dist
        variable = hetero_loss_modulus_dist_auxvariable
        execute_on = initial
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
        file_base = '_synthetic_viscoelastic_waves/syntheticdata'
        type = Exodus
        execute_on = final
    []
    [u_all]
        file_base = '_synthetic_viscoelastic_waves/'
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
