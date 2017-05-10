/**
	\author: 	Trasier
	\date: 		2017/5/9
	\brief: 	Define of the interrupt system needed
*/
`define ExcepCode_WIDTH 	5
`define ExcepCode_NONE		5'd0
`define ExcepCode_DSI		5'd1
`define ExcepCode_ISI		5'd2
`define ExcepCode_IMISS		5'd3
`define ExcepCode_DMISS		5'd4
`define ExcepCode_SC		5'd6
`define ExcepCode_DEV0		5'd7
`define ExcepCode_DEV1		5'd8
`define ExcepCode_TRAP		5'd9
`define ExcepCode_PRIV		5'd10
`define ExcepCode_ILLE		5'd11

`define SPR_ESR_ST			8
`define SPR_ESR_PIL			4	
`define SPR_ESR_PPR			5
`define SPR_ESR_PTR			6