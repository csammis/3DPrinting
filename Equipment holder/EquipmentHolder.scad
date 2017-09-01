scale = 3;

hook_thickness = 5 / scale;
hook_top_thickness = 8 / scale;
hook_height = 120 / scale;
hook_width = 400 / scale;
hook_inside_standoff_height = 40 / scale;
holder_ring_height = hook_height * 0.75;
// 60 works for a 10 gallon tank, 66 works for a 29 gallon tank
top_hook_length = 66 / scale;

// Equipment offsets (from center)
temp_probe_offset   =  -7;
topoff_fill_offset  = -58;
float_switch_offset = -35;
feeding_ring_offset =  36.65;

module hook()
{
    hook_inside_standoff_length = 40 / scale;
    hook_standoff_thickness = 5 / scale;
    
    // Values for the part of the bracket bracing against the tank rim
    outside_hook_thickness = hook_standoff_thickness + 2; // Slightly thicker to accomodate screws
    outside_hook_length = 62 / scale;
    corner_radius = outside_hook_thickness / 2;
    corner_resolution = 30;
    
    screw_hole_diameter = 2.8;
    
    translate([0, 0, hook_height / 2])
    {
        // Vertical part of the hook
        cube([hook_standoff_thickness, hook_width, hook_height], center=true);
        
        // Standoff on the inside of the tank
        translate([hook_inside_standoff_length / 2, 0, (hook_height / -2) + hook_inside_standoff_height])
            cube([hook_inside_standoff_length, hook_width, hook_standoff_thickness], center=true);
        
        // Connector
        translate([(top_hook_length / 2), 0, (hook_height / 2) - (hook_top_thickness / 2)])
        {
            hull()
            {
                tmp_length = 1;
                translate([(top_hook_length - tmp_length) * -0.5, 0, 0])
                    cube([tmp_length, hook_width, hook_top_thickness], center=true);
                translate([top_hook_length * 0.5 + corner_radius, 0, hook_top_thickness * -0.5])
                {
                    translate([0, hook_width *  0.5 - corner_radius, 0])
                        cylinder(r=corner_radius, h=hook_top_thickness, $fn=corner_resolution);
                    translate([0, hook_width * -0.5 + corner_radius, 0])
                        cylinder(r=corner_radius, h=hook_top_thickness, $fn=corner_resolution);
                }
            }
        }
        
        // Brace against the tank rim
        translate([top_hook_length + corner_radius, 0, (hook_height / 2) + (outside_hook_length / -2)])
        {
            difference()
            {
                hull()
                {
                    cube([outside_hook_thickness, hook_width - (corner_radius * 2), outside_hook_length], center=true);
                    translate([0, hook_width / 2 - corner_radius, outside_hook_length / -2])
                        cylinder(r=corner_radius, h=outside_hook_length, $fn=corner_resolution);
                    translate([0, hook_width / -2 + corner_radius, outside_hook_length / -2])
                        cylinder(r=corner_radius, h=outside_hook_length, $fn=corner_resolution);
                }
                
                // Holes for M3 screws
                translate([outside_hook_thickness * -0.75, 0, outside_hook_length * -0.2])
                {
                    translate([0, feeding_ring_offset * 1.5, 0])
                        rotate([0, 90, 0])
                            cylinder(r=screw_hole_diameter / 2, h=outside_hook_thickness + 2, $fn=corner_resolution);
                    
                    translate([0, feeding_ring_offset * 0.5, 0])
                        rotate([0, 90, 0])
                            cylinder(r=screw_hole_diameter / 2, h=outside_hook_thickness + 2, $fn=corner_resolution);
                    
                    translate([0, float_switch_offset + (topoff_fill_offset - float_switch_offset) / 2, 0])
                        rotate([0, 90, 0])
                            cylinder(r=screw_hole_diameter / 2, h=outside_hook_thickness + 2, $fn=corner_resolution);
                }
            }
        }
    }
}

// Generic ring for holding a cylindrical object (probe, cord, airline, etc.)
module holder_ring(inner_diameter, wall_thickness, height)
{
    ring_resolution = 30;

    difference()
    {
        cylinder(r=(inner_diameter / 2) + wall_thickness, h=height, $fn=ring_resolution);
        translate([0, 0, -0.5])
            cylinder(r=inner_diameter / 2, h=height + 1, $fn=ring_resolution);

        // Open up 4/5s of the inner diameter to put the object through
        translate([inner_diameter / 2, 0, height / 2])
            cube([inner_diameter, (inner_diameter * 4) / 5, height * 2], center=true);
    }
}

module topoff_fill()
{
    airline_outer_diameter = 6.5;
    holder_wall_thickness = 2;
    airline_ring_height = 5;
    holder_height = hook_height * 0.75;
    
    translate([airline_outer_diameter * -1 + holder_wall_thickness, 0, holder_height])
        rotate([0, 0, 180])
            holder_ring(airline_outer_diameter, holder_wall_thickness, airline_ring_height);
    translate([top_hook_length + airline_outer_diameter + holder_wall_thickness * 0.5, 0, holder_height])
        holder_ring(airline_outer_diameter, holder_wall_thickness, airline_ring_height);
}

module temp_probe()
{
    probe_outer_diameter = 13.75;
    probe_ring_height = 10;
    cord_outer_diameter = 4;
    holder_wall_thickness = 2;
    
    translate([probe_outer_diameter * -0.60, 0, holder_ring_height - probe_ring_height])
        rotate([0, 0, 180])
            holder_ring(probe_outer_diameter, holder_wall_thickness, probe_ring_height);
    translate([top_hook_length + cord_outer_diameter + holder_wall_thickness, 0, holder_ring_height])
        holder_ring(cord_outer_diameter, holder_wall_thickness, 5);
}

module float_switch()
{
    cord_outer_diameter = 4;
    holder_wall_thickness = 2;
    float_switch_plate_length = 23; // Must be long enough out so that the switch doesn't contact the bracket
    float_switch_plate_width = 16;
    float_switch_plate_thickness = 5;
    float_switch_stem_diameter = 8;
    float_switch_plate_corners = 2;
    
    translate([float_switch_plate_length * -0.5, 0, holder_ring_height])
    {
        difference()
        {
            // Holder plate is connected squarely with the bracket and rounded at the ends
            hull()
            {
                //cstodo I think I used the wrong variable here
                translate([float_switch_plate_width - (5 * 1.5), 0, 0])
                    cube([5, float_switch_plate_width, float_switch_plate_thickness], center=true);
                translate([float_switch_plate_length * -0.5 + float_switch_plate_corners, 0, float_switch_plate_thickness * -0.5])
                {
                    translate([0, float_switch_plate_width * 0.5  - float_switch_plate_corners, 0])
                        cylinder(r=float_switch_plate_corners, h=float_switch_plate_thickness, $fn=30);
                    translate([0, float_switch_plate_width * -0.5 + float_switch_plate_corners, 0])
                        cylinder(r=float_switch_plate_corners, h=float_switch_plate_thickness, $fn=30);
                }
            }

            // Cut out a notch in the front for the stem of the switch
            union()
            {
                translate([float_switch_stem_diameter * -1.25, 0, 0])
                    cube([float_switch_stem_diameter, float_switch_stem_diameter, float_switch_plate_thickness + 2], center=true);
                translate([float_switch_plate_length * -0.25, 0, float_switch_plate_thickness * -0.75])
                    cylinder(r=float_switch_stem_diameter / 2, h=float_switch_plate_thickness + 2, $fn=30);
            }
        }
    }
    
    translate([top_hook_length + cord_outer_diameter + holder_wall_thickness, 0, holder_ring_height])
        holder_ring(cord_outer_diameter, holder_wall_thickness, 5);
}

module feeding_ring()
{
    ring_radius = 100 / scale;
    ring_height = 75 / scale;
    ring_thickness = 10 / scale;
    ring_resolution = 75;
    
    feeder_width = 60;
    feeder_length = 130 - (ring_radius); // The mouth of the feeder should be roughly centered in the ring
    feeder_plate_thickness = hook_top_thickness;
    corner_radius = 2;
    corner_resolution = 30;
    
    translate([ring_radius * -1 + hook_thickness * 0.50, 0, 0])
    {
        difference()
        {
            cylinder(r=ring_radius, h=ring_height, $fn=ring_resolution);
            translate([0, 0, -1])
            cylinder(r=ring_radius - ring_thickness, h=ring_height + 2, $fn=ring_resolution);
        }
    }
    
    translate([(feeder_length / 2), 0, hook_height - feeder_plate_thickness * 0.5])
    {
        hull()
        {
            tmp_length = 1;
            translate([(feeder_length - tmp_length) * -0.5, 0, 0])
                cube([tmp_length, feeder_width, feeder_plate_thickness], center=true);
            translate([feeder_length * 0.5 - corner_radius, 0, feeder_plate_thickness * -0.5])
            {
                translate([0, feeder_width *  0.5 - corner_radius, 0])
                    cylinder(r=corner_radius, h=feeder_plate_thickness, $fn=corner_resolution);
                translate([0, feeder_width * -0.5 + corner_radius, 0])
                    cylinder(r=corner_radius, h=feeder_plate_thickness, $fn=corner_resolution);
            }
        }
    }
}

difference()
{
    union()
    {
        hook();
        translate([0, temp_probe_offset, 0])
            temp_probe();
        translate([0, float_switch_offset, 0])
            float_switch();
        translate([0, topoff_fill_offset, 0])
            topoff_fill();
        translate([0, feeding_ring_offset, 0])
        {
            feeding_ring();
        }
    }
    
    // Cut off the bottom part of the hook except by the feeding ring
    translate([0, feeding_ring_offset * -1.5, 0])
        cube([hook_thickness + 1, hook_width, hook_inside_standoff_height * 2 - hook_thickness], center=true);
}