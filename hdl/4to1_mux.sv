module four_mux
    (
        input logic [31:0] d_0, d_1, d_2, d_3,
        input logic [2:0] sel,
        output logic [31:0] z
    );

    assign z = sel[1] ? (sel[0] ? d_3 : d_2) : (sel[0] ? d_1 : d_0);

endmodule