smoothness = 100;
h = 60;
r = 140;
outer_wall = 5;

inner_h = h - 2*outer_wall;

sensor_r = 8;
sensor_w = 3;
sensor_h = 12;
sensor_dist = 20;
sensor_back = 2;
sensor_ramp_len = 20;
sensor_dist_to_edge = 15;
sensor_cable_hole_r = 4;
mount_fix_r = 20;
mount_fix_wall = 3;
spacing = 1;

//base + mid
difference() {
    union() {
        //base - plate
        cylinder(h =2*outer_wall, r1 = r, r2 = r,center = false, $fn = smoothness);
        //center: outer ring
        translate([0,0, 2*outer_wall])
        difference() {
            cylinder(h =inner_h, r1 = mount_fix_r + 2*mount_fix_wall + spacing, r2 = mount_fix_r + 2*mount_fix_wall+ spacing,center = false, $fn = smoothness);
            cylinder(h =inner_h, r1 = mount_fix_r + mount_fix_wall+ spacing, r2 = mount_fix_r + mount_fix_wall+ spacing,center = false, $fn = smoothness);
        }
        //center: inner - ring
        translate([0,0, 2*outer_wall])
        difference() {
                           cylinder(h =inner_h- 2*spacing, r1 = mount_fix_r- spacing, r2 = mount_fix_r- spacing,center = false, $fn = smoothness);
            translate([0,mount_fix_r - mount_fix_wall , inner_h/2])
            cube([2*mount_fix_wall+ spacing,2*mount_fix_wall+ spacing,inner_h] ,center = true);
        }
        
       //outer ring
        translate([0,0, 2*outer_wall])
        difference() {
            cylinder(h =inner_h, r1 = r - outer_wall - spacing, r2 = r - outer_wall - spacing,center = false, $fn = smoothness);
            cylinder(h =inner_h, r1 = r - 2*outer_wall - spacing, r2 = r - 2*outer_wall - spacing,center = false, $fn = smoothness);
        }
    }
    //center fixture screw hole
    cylinder(h = inner_h + 2*outer_wall, r1 = sensor_cable_hole_r, r2 = sensor_cable_hole_r,center = false, $fn = smoothness);
    cylinder(h = outer_wall, r1 = 2*sensor_cable_hole_r, r2 = 2*sensor_cable_hole_r,center = false, $fn = smoothness);
    
    //water outlet
    translate([0,mount_fix_r +mount_fix_wall/2, 0])
    cylinder(h = inner_h + 2*outer_wall, r1 =mount_fix_wall/2, r2 = mount_fix_wall/2,center = false, $fn = smoothness);
    translate([0,-mount_fix_r-mount_fix_wall/2 , 0])
    cylinder(h = inner_h + 2*outer_wall, r1 =mount_fix_wall/2, r2 = mount_fix_wall/2,center = false, $fn = smoothness);
    translate([mount_fix_r +mount_fix_wall/2,0, 0])
    cylinder(h = inner_h + 2*outer_wall, r1 =mount_fix_wall/2, r2 = mount_fix_wall/2,center = false, $fn = smoothness);
    translate([-mount_fix_r-mount_fix_wall/2 ,0, 0])
    cylinder(h = inner_h + 2*outer_wall, r1 =mount_fix_wall/2, r2 = mount_fix_wall/2,center = false, $fn = smoothness);
}