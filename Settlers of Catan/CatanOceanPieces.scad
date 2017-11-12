//
// Settlers of Catan ocean borders
// For use with the OEM hex tiles and pieces
// Design by Chris Sammis, 2017
//

/****** Constants ********************/
hex_side                = 46;
ocean_height            = 4;
ocean_segment_length    = 80;
connector_edge_length   = 12;
connector_corner_radius = 3;

/*** Helpful calculations ************/
flat_side_length    = (hex_side / 2) + 10;
connector_size      = connector_edge_length + connector_corner_radius;
connector_y_offset  = (connector_size / -2) - 3;


module hexagon(side, height)
{
    cylinder(r=side, h=height, $fn=6);
}

module ocean_connector(edge_length, edge_width, height)
{
    hull()
    {
        cube([1, edge_width, height]);
        translate([edge_length, 0, 0])
        {
            cylinder(r=connector_corner_radius, h=height, $fn=15);
        }
        translate([edge_length, edge_width, 0])
        {
            cylinder(r=connector_corner_radius, h=height, $fn=15);
        }
    }
}

// The ocean_segment is one peak in a border piece
module ocean_segment()
{
    cutout_length = ocean_segment_length + 2;
    difference()
    {
        rotate([0, 0, 30])
        {
            hexagon(hex_side, ocean_height);
        }
        translate([cutout_length / -2, 10, -0.02])
        {
            cube([cutout_length, hex_side, ocean_height + 0.04]);
        }
    }
}

module ocean_expander()
{
    connector_x_offset = (hex_side / 2 + connector_size);
    
    difference()
    {
        ocean_segment();
        
        translate([connector_x_offset - ocean_segment_length, connector_y_offset, -0.02])
        {
            ocean_connector(connector_edge_length, connector_edge_length, ocean_height + 0.04);
        }
    }
    
    // Y translate scale factor of 0.025: half of the Y dimension scale() (0.05)
    translate([connector_x_offset + connector_corner_radius / 2,
               connector_y_offset + (connector_edge_length * 0.025),
               0])
    {
        scale([0.9, 0.95, 1.0])
        {
            ocean_connector(connector_edge_length, connector_edge_length - 0.5, ocean_height);
        }
    }
}

module ocean_border()
{
    hex_inradius        = (sqrt(3) * hex_side) / 2;
    connector_x_offset  = (hex_side * 4 + connector_size);
    difference()
    {
        union()
        {
            ocean_segment();
            translate([hex_inradius * 2, 0, 0])
            {
                ocean_segment();
            }
            translate([hex_inradius * 4, 0, 0])
            {
                ocean_segment();
            }
        }
        
        cutoff_x        = sin(60) * flat_side_length * -1;
        cutoff_width    = 40;
        
        // Chop off from the side without the connector
        translate([cutoff_x - cutoff_width, -100, -0.02])
        {
            cube([cutoff_width, 200, ocean_height + 0.04]);
        }
   
        // Create the angled side. I have no idea with this Y translation. I eyeballed it.
        translate([cutoff_x, hex_inradius * -1 + 10.3, -0.02])
        {
            rotate([0, 0, 60])
            {
                cube([50, 50, ocean_height + 0.04]);
            }
        }
        
        connector_x = cutoff_x * (2.25/6); // A tiny bit more than a third
        translate([connector_x, -41, -0.02])
        {
            rotate([0, 0, 60])
            {
                ocean_connector(connector_edge_length, connector_edge_length, ocean_height + 0.04);
            }
        }
    }
    
    // Y translate scale factor of 0.025: half of the Y dimension scale() (0.05)
    translate([connector_x_offset, connector_y_offset + (connector_edge_length * 0.025), 0])
    {
        scale([0.9, 0.95, 1.0])
        {
            ocean_connector(connector_edge_length, connector_edge_length - 0.5, ocean_height);
        }
    }
}

// The base game includes six ocean_border() pieces
ocean_border();

// The 5-6 player expansion includes four ocean_expander() pieces
//ocean_expander();
