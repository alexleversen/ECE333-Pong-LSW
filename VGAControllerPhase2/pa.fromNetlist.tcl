
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name VGAControllerPhase2 -dir "C:/Users/williaad/Documents/Junior/ECE333/finalprojGIT/ECE333-Pong-LSW/ECE333-Pong-LSW/VGAControllerPhase2/planAhead_run_2" -part xc6slx16csg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/williaad/Documents/Junior/ECE333/finalprojGIT/ECE333-Pong-LSW/ECE333-Pong-LSW/VGAControllerPhase2/PongwithSoundandFeatures.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/williaad/Documents/Junior/ECE333/finalprojGIT/ECE333-Pong-LSW/ECE333-Pong-LSW/VGAControllerPhase2} {ipcore_dir} }
set_property target_constrs_file "pongNewDriverTemplate2015Spring.ucf" [current_fileset -constrset]
add_files [list {pongNewDriverTemplate2015Spring.ucf}] -fileset [get_property constrset [current_run]]
link_design
