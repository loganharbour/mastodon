[Mesh]
  type = FileMesh
  file = contact_modified.e
  patch_update_strategy = iteration
  patch_size = 40
  partitioner = centroid
  centroid_partitioner_direction = y
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  volumetric_locking_correction = true
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[AuxVariables]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_zx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./nor_forc]
    order = FIRST
    family = LAGRANGE
  [../]
  [./nor_forc_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./tang_forc]
    order = FIRST
    family = LAGRANGE
  [../]
  [./tang_forc_x]
    order = FIRST
    family = LAGRANGE
  [../]
  []

[Kernels]
  [./TensorMechanics]
    use_displaced_mesh = true
    displacements = 'disp_x disp_y disp_z'
  [../]
    [./gravity]
      type = Gravity
      variable = disp_z
      value = -386.09   #in/s2
    [../]

[]

[AuxKernels]
  [./nor_forc_z]
    type = PenetrationAux
    variable = nor_forc_z
    quantity = normal_force_z
    boundary = 102
    paired_boundary = 103
  [../]
  [./nor_forc]
    type = PenetrationAux
    variable = nor_forc
    quantity = normal_force_magnitude
    boundary = 102
    paired_boundary = 103
  [../]
  [./tang_forc_x]
    type = PenetrationAux
    variable = tang_forc_x
    quantity = tangential_force_x
    boundary = 102
    paired_boundary = 103
  [../]
  [./tang_forc]
    type = PenetrationAux
    variable = tang_forc
    quantity = tangential_force_magnitude
    boundary = 102
    paired_boundary = 103
  [../]
  [./stress_zx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zx
    index_i = 2
    index_j = 0
  [../]
  [./strain_zx]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = strain_zx
    index_i = 2
    index_j = 0
  [../]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  [../]
[]

[BCs]
[./fix_x_soil]
  type = PresetBC
  variable = disp_x
  boundary = 100
  value = 0.0
[../]
[./fix_y_soil]
   type = PresetBC
   variable = disp_y
   boundary = 100
   value = 0.0
[../]
[./fix_z_soil]
   type = PresetBC
   variable = disp_z
   boundary = 100
   value = 0.0
[../]

 [./concrete_pressure]
    type = Pressure
    boundary = 101
    variable = disp_z
    component = 2
    factor = 5 #psi
 [../]
[]

[Materials]
  [./elasticity_tensor_block]
    youngs_modulus = 4e6 #psi
    poissons_ratio = 0.25
    type = ComputeIsotropicElasticityTensor
    block = 2
  [../]
  [./strain_block]
    type = ComputeFiniteStrain
    block = 2
    displacements = 'disp_x disp_y disp_z'
  [../]
  [./stress_block]
    type = ComputeFiniteStrainElasticStress
  #  store_stress_old = true
    block = 2
  [../]
  [./den_block]
    type = GenericConstantMaterial
    block = 2
    prop_names = density
    prop_values = 0.0002248 #slug/in^3
  [../]

  [./elasticity_tensor_soil]
  youngs_modulus = 1.3983e+05 #psi
   poissons_ratio = 0.3
   type = ComputeIsotropicElasticityTensor
   block = 1
  [../]

  [./strain_soil]
   type = ComputeFiniteStrain
   block = 1
   displacements = 'disp_x disp_y disp_z'
  [../]
  [./stress_soil]
   type = ComputeFiniteStrainElasticStress
   block = 1
  [../]
  [./den_soil]
   type = GenericConstantMaterial
   block = 1
   prop_names = density
   prop_values = 0.0001356 #slug/in^3
#   prop_values = 0.3
  [../]
[]

[Contact]
  [./leftright]
    slave = 102
    master = 103
    system = constraint
    model = coulomb
    formulation = penalty
    normalize_penalty = true
    friction_coefficient = 0.7
    penalty = 1e5
    displacements = 'disp_x disp_y disp_z'
  [../]
[]

[Preconditioning]
  [./andy]
    type = SMP
    full = true
  [../]
[]

[Postprocessors]
  [./nor_forc]
    type = NodalSum
    variable = nor_forc
    boundary = 102
  [../]
  [./nor_forc_z]
    type = NodalSum
    variable = nor_forc_z
    boundary = 102
  [../]
  [./tang_forc_x]
    type = NodalSum
    variable = tang_forc_x
    boundary = 102
  [../]
  [./stres_xx_interface]
    type = SideAverageValue
  boundary = 102
  variable = stress_xx
  [../]
  [./stres_yy_interface]
  type = SideAverageValue
  boundary = 102
  variable = stress_yy
  [../]
  [./stres_zz_interface]
  type = SideAverageValue
  boundary = 102
  variable = stress_zz
  [../]
  [./strain_zx_interface]
  type = SideAverageValue
  boundary = 102
  variable = strain_zx
  [../]
  [./stress_zx_interface]
  type = SideAverageValue
  boundary = 102
  variable = stress_zx
  [../]
  [./dispx]
    type = NodalMaxValue
    block = '2'
    variable = disp_x
  [../]
[]


[Executioner]
  type = Transient
  solve_type = 'PJFNK'

   petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
   petsc_options_value = 'lu     superlu_dist'

  line_search = 'none'
  end_time = 2.0
  dt = 0.005
  dtmin = 0.001
  nl_abs_tol = 1e-1
  nl_rel_tol = 1e-4
  l_tol = 1e-2
  l_max_its = 20
  timestep_tolerance = 1e-3
[]






[Outputs]
  csv = true
  exodus = true
perf_graph  = true
  [./console]
    type = Console
    max_rows = 1
  [../]
  [./out1]
    type = Checkpoint
    interval = 1
    num_files = 2
  [../]
[]
