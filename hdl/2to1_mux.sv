module two_mux
    (
        input logic [31:0] d_0, d_1,
        input logic sel,
        output logic [31:0] z
    );

    assign z = sel ? d_1 : d_0;

endmodule