# CUMCM2019-A
Code for CUMCM 2019 Problem A



支撑材料中*.mat为数据拟合所产生的数据材料，含：

- EP_model.mat - 附录1拟合函数
- ValveModel.mat - 问题2针阀模型数据表
- TD_model_ori.mat - 附录2拟合函数
- RhoTheta_model.mat - 附录3拟合函数
- Rho_P_model.mat - 密度-压强关系表
- P_Rho_model.mat - 压强-密度关系表
- Q.mat - 可由cam.m生成的高压油泵数据表



脚本与函数：

- density.m density_approx.m pressure.m pressure_apporx.m为密度压强转换函数
- integration.m - 第一题微分方程积分打表，可调整x的上下界
- simulation.m - 第一题仿真，open_time/100ms效率工作，可调整参数含open_time: 每周期油泵工作时间(ms)，t_total: 仿真总时长(s)，t_interval: 仿真采样时间间隔(s)
- cam.m - 高压油泵仿真，可调整参数含omega: 凸轮角速度(rad/s)
- simulation_acu.m - 第二、三题仿真，不含减压阀，可调整参数含t_total，t_interval（同上），omega: 凸轮角速度(rad/s，单喷油管可设为35.3)
- simulation_PID.m - PID仿真，可调整参数含t_total，t_interval（同上），omega: 凸轮角速度(rad/s)，减压阀上下阈值（hard code写定），t_delay: 喷油管延时(s)，PID参数，p: 初始压强(MPa)