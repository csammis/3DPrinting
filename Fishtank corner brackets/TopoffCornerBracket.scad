rim_height = 7.5;
rim_width = 11.85;

bracket_length = 70;
bracket_width = 20;
edge_width = 2;

CUTOUT_LENGTH = 100;

float_switch_plate_length = 23;
float_switch_plate_width = 16;
float_switch_plate_thickness = 5;

switch_cord_diameter = 4;
switch_cord_wall_width = 2;

airline_diameter = 6.5;

// Generic ring for holding a cylindrical object (probe, cord, airline, etc.)
module holder_ring(inner_diameter, wall_width, height)
{
    ring_resolution = 30;

    difference()
    {
        cylinder(r=(inner_diameter / 2) + wall_width, h=height, $fn=ring_resolution);
        translate([0, 0, -0.01])
            cylinder(r=inner_diameter / 2, h=height + 0.02, $fn=ring_resolution);

        // Open up 4/5s of the inner diameter to put the object through
        translate([inner_diameter / 2, 0, height / 2])
            cube([inner_diameter, (inner_diameter * 4) / 5, height * 2], center=true);
    }
}

module float_switch()
{
    float_switch_stem_diameter = 8;
    float_switch_plate_corners = 2;
    
    difference()
    {
        // Holder plate is connected squarely with the bracket and rounded at the ends
        hull()
        {
            cube([1, float_switch_plate_width, float_switch_plate_thickness]);
            translate([float_switch_plate_length * 1 + float_switch_plate_corners, 0])
            {
                translate([0, float_switch_plate_width - float_switch_plate_corners, 0])
                    cylinder(r=float_switch_plate_corners, h=float_switch_plate_thickness, $fn=30);
                translate([0, float_switch_plate_corners, 0])
                    cylinder(r=float_switch_plate_corners, h=float_switch_plate_thickness, $fn=30);
            }
        }

        // Cut out a notch in the front for the stem of the switch
        union()
        {
            translate([float_switch_plate_length, float_switch_plate_width / 4, -0.01])
                cube([float_switch_stem_diameter, float_switch_stem_diameter, float_switch_plate_thickness + 0.02]);
            translate([float_switch_plate_length, float_switch_plate_width / 2, -0.01])
                cylinder(r=float_switch_stem_diameter / 2, h=float_switch_plate_thickness + 0.02, $fn=30);
        }
    }
}

difference()
{
    translate([edge_width * -1, edge_width * -1, 0.01])
    {
        union()
        {
            cube([bracket_length, bracket_width, rim_height + edge_width]);
            
            // Float switch parts: bracket + cord holder
            translate([bracket_length, bracket_width - 0.01, rim_height + edge_width - float_switch_plate_thickness])
                rotate([0, 0, 90])
                    float_switch();
            translate([bracket_length - float_switch_plate_width / 2, -2, rim_height + edge_width - float_switch_plate_thickness])
                rotate([0, 0, -90])
                    holder_ring(switch_cord_diameter, switch_cord_wall_width, float_switch_plate_thickness);
            
            // Topoff line parts: inner and outer holders
            translate([bracket_length * 0.5, bracket_width + airline_diameter / 2, rim_height + edge_width - float_switch_plate_thickness])
                rotate([0, 0, 90])
                    holder_ring(airline_diameter, switch_cord_wall_width, float_switch_plate_thickness);
            
            translate([bracket_length * 0.5, airline_diameter / -2, rim_height + edge_width - float_switch_plate_thickness])
                rotate([0, 0, -90])
                    holder_ring(airline_diameter, switch_cord_wall_width, float_switch_plate_thickness);
        }
    }
    
    union()
    {
        cube([CUTOUT_LENGTH, rim_width, rim_height]);
        translate([rim_width, 0, 0])
        rotate([0, 0, 90])
            cube([CUTOUT_LENGTH, rim_width, rim_height]);
    }
}