	// Instance Bypass Mux
	mux32 #(32) GPR_rd0_D_Bmux (
		.din26( 0/* empty */ ),
		.din27( 0/* empty */ ),
		.din24( 0/* empty */ ),
		.din25( 0/* empty */ ),
		.din22( 0/* empty */ ),
		.din23( 0/* empty */ ),
		.din20( 0/* empty */ ),
		.din21( 0/* empty */ ),
		.din28( 0/* empty */ ),
		.din29( 0/* empty */ ),
		.dout(GPR_rd0_D_Bmux_dout_D),
		.din31( 0/* empty */ ),
		.sel(GPR_rd0_D_Bmux_sel_D),
		.din30( 0/* empty */ ),
		.din13(SPR_rd0_MB),
		.din12(MDU_C_ME),
		.din11(SPR_rd0_W),
		.din10(CR_MOVE_CRwd_ME),
		.din17(MSR_rd_E),
		.din16(CR_MOVE_CRwd_W),
		.din15(SPR_rd0_ME),
		.din14(MDU_C_W),
		.din19( 0/* empty */ ),
		.din18(MSR_rd_W),
		.din7(ALU_C_W),
		.din6(ALU_C_MB),
		.din5(ALU_C_ME),
		.din4(SPR_rd0_E),
		.din3(MSR_rd_MB),
		.din2(DMOut_ME_dout_W),
		.din1(MSR_rd_ME),
		.din0(GPR_rd0_D),
		.din9(CR_MOVE_CRwd_MB),
		.din8(MDU_C_MB)
	);

	mux8 #(32) GPR_rd0_E_Bmux (
		.dout(GPR_rd0_E_Bmux_dout_E),
		.din7( 0/* empty */ ),
		.din6( 0/* empty */ ),
		.din5( 0/* empty */ ),
		.din4(CR_MOVE_CRwd_MB),
		.din3(MDU_C_MB),
		.din2(ALU_C_MB),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd0_E),
		.sel(GPR_rd0_E_Bmux_sel_E)
	);

	mux32 #(32) GPR_rd1_D_Bmux (
		.din26( 0/* empty */ ),
		.din27( 0/* empty */ ),
		.din24( 0/* empty */ ),
		.din25( 0/* empty */ ),
		.din22( 0/* empty */ ),
		.din23( 0/* empty */ ),
		.din20( 0/* empty */ ),
		.din21( 0/* empty */ ),
		.din28( 0/* empty */ ),
		.din29( 0/* empty */ ),
		.dout(GPR_rd1_D_Bmux_dout_D),
		.din31( 0/* empty */ ),
		.sel(GPR_rd1_D_Bmux_sel_D),
		.din30( 0/* empty */ ),
		.din13(SPR_rd0_MB),
		.din12(MDU_C_ME),
		.din11(SPR_rd0_W),
		.din10(CR_MOVE_CRwd_ME),
		.din17(MSR_rd_E),
		.din16(CR_MOVE_CRwd_W),
		.din15(SPR_rd0_ME),
		.din14(MDU_C_W),
		.din19( 0/* empty */ ),
		.din18(MSR_rd_W),
		.din7(ALU_C_W),
		.din6(ALU_C_MB),
		.din5(ALU_C_ME),
		.din4(SPR_rd0_E),
		.din3(MSR_rd_MB),
		.din2(DMOut_ME_dout_W),
		.din1(MSR_rd_ME),
		.din0(GPR_rd1_D),
		.din9(CR_MOVE_CRwd_MB),
		.din8(MDU_C_MB)
	);

	mux8 #(32) GPR_rd1_E_Bmux (
		.dout(GPR_rd1_E_Bmux_dout_E),
		.din7( 0/* empty */ ),
		.din6( 0/* empty */ ),
		.din5( 0/* empty */ ),
		.din4(CR_MOVE_CRwd_MB),
		.din3(MDU_C_MB),
		.din2(ALU_C_MB),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd1_E),
		.sel(GPR_rd1_E_Bmux_sel_E)
	);

	mux32 #(32) GPR_rd2_D_Bmux (
		.din26( 0/* empty */ ),
		.din27( 0/* empty */ ),
		.din24( 0/* empty */ ),
		.din25( 0/* empty */ ),
		.din22( 0/* empty */ ),
		.din23( 0/* empty */ ),
		.din20( 0/* empty */ ),
		.din21( 0/* empty */ ),
		.din28( 0/* empty */ ),
		.din29( 0/* empty */ ),
		.dout(GPR_rd2_D_Bmux_dout_D),
		.din31( 0/* empty */ ),
		.sel(GPR_rd2_D_Bmux_sel_D),
		.din30( 0/* empty */ ),
		.din13(SPR_rd0_MB),
		.din12(MDU_C_ME),
		.din11(SPR_rd0_W),
		.din10(CR_MOVE_CRwd_ME),
		.din17(MSR_rd_E),
		.din16(CR_MOVE_CRwd_W),
		.din15(SPR_rd0_ME),
		.din14(MDU_C_W),
		.din19( 0/* empty */ ),
		.din18(MSR_rd_W),
		.din7(ALU_C_W),
		.din6(ALU_C_MB),
		.din5(ALU_C_ME),
		.din4(SPR_rd0_E),
		.din3(MSR_rd_MB),
		.din2(DMOut_ME_dout_W),
		.din1(MSR_rd_ME),
		.din0(GPR_rd2_D),
		.din9(CR_MOVE_CRwd_MB),
		.din8(MDU_C_MB)
	);

	mux8 #(32) GPR_rd2_E_Bmux (
		.dout(GPR_rd2_E_Bmux_dout_E),
		.din7( 0/* empty */ ),
		.din6( 0/* empty */ ),
		.din5( 0/* empty */ ),
		.din4(CR_MOVE_CRwd_MB),
		.din3(MDU_C_MB),
		.din2(ALU_C_MB),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd2_E),
		.sel(GPR_rd2_E_Bmux_sel_E)
	);

	mux2 #(32) GPR_rd2_MB_Bmux (
		.sel(GPR_rd2_MB_Bmux_sel_MB),
		.dout(GPR_rd2_MB_Bmux_dout_MB),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd2_MB)
	);

	mux2 #(32) GPR_rd2_ME_Bmux (
		.sel(GPR_rd2_ME_Bmux_sel_ME),
		.dout(GPR_rd2_ME_Bmux_dout_ME),
		.din1(DMOut_ME_dout_W),
		.din0(GPR_rd2_ME)
	);

	mux16 #(32) SPR_rd0_D_Bmux (
		.din13( 0/* empty */ ),
		.din12(NPC_LRwd_W),
		.din11(NPC_CTRwd_W),
		.din10(NPC_LRwd_E),
		.dout(SPR_rd0_D_Bmux_dout_D),
		.din15( 0/* empty */ ),
		.din14( 0/* empty */ ),
		.din7(NPC_CTRwd_E),
		.din6(NPC_CTRwd_ME),
		.din5(NPC_CTRwd_MB),
		.din4(GPR_rd2_W),
		.din3(GPR_rd2_E),
		.din2(NPC_LRwd_MB),
		.din1(NPC_LRwd_ME),
		.din0(SPR_rd0_D),
		.sel(SPR_rd0_D_Bmux_sel_D),
		.din9(GPR_rd2_MB),
		.din8(GPR_rd2_ME)
	);

	mux16 #(32) SPR_rd1_D_Bmux (
		.din13( 0/* empty */ ),
		.din12(NPC_LRwd_W),
		.din11(GPR_rd2_W),
		.din10(NPC_CTRwd_W),
		.dout(SPR_rd1_D_Bmux_dout_D),
		.din15( 0/* empty */ ),
		.din14( 0/* empty */ ),
		.din7(GPR_rd2_MB),
		.din6(GPR_rd2_ME),
		.din5(NPC_CTRwd_E),
		.din4(NPC_CTRwd_ME),
		.din3(NPC_LRwd_MB),
		.din2(NPC_LRwd_ME),
		.din1(NPC_CTRwd_MB),
		.din0(SPR_rd1_D),
		.sel(SPR_rd1_D_Bmux_sel_D),
		.din9(NPC_LRwd_E),
		.din8(GPR_rd2_E)
	);

	mux4 #(32) CR_rd_D_Bmux (
		.dout(CR_rd_D_Bmux_dout_D),
		.din3(CR_MOVE_CRwd_ME),
		.din2(CR_MOVE_CRwd_MB),
		.din1(CR_MOVE_CRwd_W),
		.din0(CR_rd_D),
		.sel(CR_rd_D_Bmux_sel_D)
	);

	mux2 #(32) CR_rd_E_Bmux (
		.sel(CR_rd_E_Bmux_sel_E),
		.dout(CR_rd_E_Bmux_dout_E),
		.din1(CR_MOVE_CRwd_MB),
		.din0(CR_rd_E)
	);

	mux8 #(32) MSR_rd_D_Bmux (
		.dout(MSR_rd_D_Bmux_dout_D),
		.din7( 0/* empty */ ),
		.din6( 0/* empty */ ),
		.din5( 0/* empty */ ),
		.din4(GPR_rd2_W),
		.din3(GPR_rd2_E),
		.din2(GPR_rd2_MB),
		.din1(GPR_rd2_ME),
		.din0(MSR_rd_D),
		.sel(MSR_rd_D_Bmux_sel_D)
	);