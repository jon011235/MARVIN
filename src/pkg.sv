/*
    Project:    MARVIN
    Sector:     TOP
    Entity:     pkg
    Summary:    Toplevel package file
    Device:     terasIC® DE10-Lite Development Board with Altera® MAX 10 10M50DAF484C7G FPGA
    Authors:    Leonard Pfeiffer
*/

package pkg;
    typedef struct packed { logic [3:0] red, green, blue; } color_t;
    typedef struct packed { logic a, b, c, d, e, f, g, p; } seg7p_t;

    parameter int unsigned BUS_DATA_ = 31;
    parameter int unsigned BUS_ADDR_ = 31;
endpackage
