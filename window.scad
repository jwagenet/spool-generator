

window_border_width = 5;
barrel_diameter = 30;
flange_diameter = 80;
fillet_radius = 5;
flange_width=1;
number_of_windows=4;


spin_windows(window_border_width,barrel_diameter,flange_diameter,fillet_radius,flange_width,number_of_windows);

module window(b,id,od,rad,h,n,deg){
    
    union(){
        translate([sqrt(pow(id/2+b+rad,2)-pow(b+rad,2)),b+rad,0])cylinder(h,r=rad,$fn=100);
        translate([sqrt(pow(od/2-b-rad,2)-pow(b+rad,2)),b+rad,0])cylinder(h,r=rad,$fn=100);
        rotate([0,0,deg])
        translate([sqrt(pow(id/2+b+rad,2)-pow(b+rad,2)),-b-rad,0])cylinder(h,r=rad,$fn=100);
        rotate([0,0,deg])translate([sqrt(pow(od/2-b-rad,2)-pow(b+rad,2)),-b-rad,0])cylinder(h,r=rad,$fn=100);
        translate([sqrt(pow(id/2+b+rad,2)-pow(b+rad,2)),b,0])cube([od/2-b-rad-(id/2+b+rad),b,h]);
        rotate([0,0,deg])translate([sqrt(pow(id/2+b+rad,2)-pow(b+rad,2)),-2*b,0])cube([od/2-b-rad-(id/2+b+rad),5,h]);      
        
//        translate([(b+rad)/tan(deg/2),b+rad,0])cylinder(1,1);        
//        translate([(id/2+b)*cos(atan((b+rad)/sqrt(pow(id/2+b+rad,2)-pow(b+rad,2)))),(id/2+b)*sin(atan((b+rad)/sqrt(pow(id/2+b+rad,2)-pow(b+rad,2)))),0])cylinder(1,1);
//        translate([(od/2-b)*cos(atan((b+rad)/sqrt(pow(od/2-b-rad,2)-pow(b+rad,2)))),(od/2-b)*sin(atan((b+rad)/sqrt(pow(od/2-b-rad,2)-pow(b+rad,2)))),0])cylinder(1,1);
//        translate([(od/3)/tan(deg/2),od/3,0])cylinder(1,1);
//        translate([(od/2-b)*cos(deg-atan((b+rad)/(od/2-b-rad))),(od/2-b)*sin(deg-atan((b+rad)/(od/2-b-rad))),0])cylinder(1,1);
//        translate([(id/2+b)*cos(deg-atan((b+rad)/(id/2+b+rad))),(id/2+b)*sin(deg-atan((b+rad)/(id/2+b+rad))),0])cylinder(1,1);
    
        intersection(){
            difference(){
                cylinder(h,r=od/2-b,$fn=100);
                translate([0,0,-.1])cylinder(h+.2,r=id/2+b,$fn=100);
            }
            translate([0,0,-.1])linear_extrude(h+.2)polygon([[0,0],[(id/2+b)*cos(atan((b+rad)/sqrt(pow(id/2+b+rad,2)-pow(b+rad,2)))),(id/2+b)*sin(atan((b+rad)/sqrt(pow(id/2+b+rad,2)-pow(b+rad,2))))],[(od/2-b)*cos(atan((b+rad)/sqrt(pow(od/2-b-rad,2)-pow(b+rad,2)))),(od/2-b)*sin(atan((b+rad)/sqrt(pow(od/2-b-rad,2)-pow(b+rad,2))))],[(od/2)/tan(deg/2),od/2],[(od/2-b)*cos(deg-atan((b+rad)/(od/2-b-rad))),(od/2-b)*sin(deg-atan((b+rad)/(od/2-b-rad)))],[(id/2+b)*cos(deg-atan((b+rad)/(id/2+b+rad))),(id/2+b)*sin(deg-atan((b+rad)/(id/2+b+rad)))]]);
        }
    }
}

module spin_windows(b,id,od,rad,h,n){
    deg = 360/n;    
    for (i = [0:n-1]){
        rotate([0,0,deg*i])
    window(b,id,od,rad,h,n,deg);
    }
}
