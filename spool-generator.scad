/*  Spool Generator: Generate custom size spools and reels for wire, filament, string, etc.
    By Jonathan Wagenet 2016-01-17
   
*/   


/* [Component Type] */
type					= "cap";    //[cap,body,barrel]

/* [Window Type] */
window_type		    	= "web";    //[film,web]

spool_diameter          = 20;
drum_diameter           = 27;
drum_width              = 5;
flange_diameter         = 65;
flange_width            = 1.5;

thread_length           = 4;
thread_pitch            = 2;
thread_outer_diameter   = 24;
thread_inner_diameter   = 25;

window_border_width     = 5;
window_fillet_radius    = 3;
number_of_windows       = 6;

number_of_eyelets       = 2;
sets_of_eyelets         = 3;
eyelet_diameter         = 2;
eyelet_spacing          = 5;
eyelet_edge_distance    = 3;





//Spool Cap
if (type=="cap")
{
    spool_cap(spool_diameter,drum_diameter,drum_width,flange_diameter,flange_width,thread_length,thread_pitch,thread_outer_diameter,window_border_width,window_fillet_radius,number_of_windows,number_of_eyelets,sets_of_eyelets,eyelet_diameter,eyelet_spacing,eyelet_edge_distance);
        
}

//Spool Body
if (type=="body")
{
    spool_body(spool_diameter,drum_diameter,drum_width,flange_diameter,flange_width,thread_length,thread_pitch,thread_inner_diameter,window_border_width,window_fillet_radius,number_of_windows,number_of_eyelets,sets_of_eyelets,eyelet_diameter,eyelet_spacing,eyelet_edge_distance);
}

//Spool Barrel
if (type=="barrel")
{
	barrel(spool_diameter,drum_diameter,drum_width,thread_length,thread_pitch,thread_outer_diameter);
}



module spool_cap(sd,dd,dw,fd,fw,tl,tp,tid,wdw,wfr,nw,ne,se,ed,es,eed){
    difference(){
        union(){
            flange(fd,fw,dd,wdw,wfr,nw,ne,se,ed,es,eed);
            translate([0,0,fw])screw_thread(tid,tp,45,tl,1,2);
        }
        translate([0,0,-.1])cylinder(fw+tl+.2,d=sd,$fn=100);
        translate([0,0,-.1])countersink_end(.5,sd+1,45,1,tl+1,1);
    }
}

module spool_body(sd,dd,dw,fd,fw,tl,tp,tod,wdw,wfr,nw,ne,se,ed,es,eed){
    difference(){
        union(){
            flange(fd,fw,dd,wdw,wfr,nw,ne,se,ed,es,eed);
            translate([0,0,fw+dw-tl-.5])internal_thread(sd,dd,dw,fd,fw,tl,tp,tod);
            translate([0,0,fw])cylinder(dw-tl-.5,d=dd,$fn=100);
        }       
        translate([0,0,-.1])cylinder(fw+dw+.2,d=sd,$fn=100);
        translate([0,0,-.1])countersink_end(.5,sd+1,45,1,tl+1,1);
        translate([0,0,fw+ed/2])rotate([0,90,0])cylinder(dd,d=ed,$fn=20);
    }
}

module internal_thread(sd,dd,dw,fd,fw,tl,tp,tod){
    difference(){
    
        cylinder(tl+.5,d=dd,$fn=100);
        union(){
            translate([0,0,-.1])screw_thread(tod,tp,45,tl+0.5+.1,1,1);
        }     
        translate([0,0,tl+.5-tp/2+0.1])countersink_end(tp/2,tod,45,1,tl+1,0);
        *translate([0,0,-.1])cylinder(fw+tl*tp+.2,d=20,$fn=100);
    }
}

module barrel(sd,dd,dw,tl,tp,tod){
    difference(){
        cylinder(dw,d=dd,$fn=100);
        translate([0,0,-.1])cylinder(dw+.2,d=tod-tp,$fn=100);
        translate([0,0,-.1])countersink_end(tp/2,tod,45,1,tl+1,1);
        translate([0,0,dw-tp/2+.1])countersink_end(tp/2,tod,45,1,tl+1,0);
        screw_thread(tod,tp,45,tl+.5,1,1);    
        translate([0,0,dw-tl-.5])screw_thread(tod,tp,45,tl+.5,1,1);  
    }
}

module countersink_end(chg,cod,clf,crs,hg,flip){
    if (flip == 0){
        cylinder(h=chg+0.01, 
             r1=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             r2=cod/2, 
             $fn=floor(cod*PI/crs), center=false);
    }else{
        cylinder(h=chg+0.01, 
             r2=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             r1=cod/2, 
             $fn=floor(cod*PI/crs), center=false);
    }
}


// Flange
module flange(fd,fw,dd,wbw,wfr,nw,ne,se,ed,es,eed){
    difference(){
        cylinder(fw,d=fd,$fn=100);
        if (nw > 1){
            
            translate([0,0,-.1])spin_windows(wbw,dd,fd,wfr,fw,nw);
        }
        if (ne > 0 && se >0){
            eyelets(ne,se,ed,es,eed,fd,fw);
        }
    }
}

module eyelets(ne,se,ed,es,eed,fd,fw){
    a = 360/(fd-2*eed)/PI*es;
    deg = 360/se;    
    for (i = [0:se-1]){
        for (j = [0:ne-1]){
        rotate([0,0,deg*i+a*j-a*(ne-1)/2])translate([fd/2-eed,0,-.1])
        cylinder(fw+.2,d=ed,$fn=20);
        }
    }
}

// Flange Windows
module film_window(b,id,od,fw){
    translate([(od+id)/4,0,0])cylinder(fw+.2,d = (od-id)/2-2*b,$fn = 32);
    
}

module window(b,id,od,rad,h,n,deg){
    w = b/2;
       
    
    union(){
        translate([sqrt(pow(id/2+b+rad,2)-pow(w+rad,2)),w+rad,0])cylinder(h+.2,r=rad,$fn=100);
        translate([sqrt(pow(od/2-b-rad,2)-pow(w+rad,2)),w+rad,0])cylinder(h+.2,r=rad,$fn=100);
        rotate([0,0,deg])
        translate([sqrt(pow(id/2+b+rad,2)-pow(w+rad,2)),-w-rad,0])cylinder(h+.2,r=rad,$fn=100);
        rotate([0,0,deg])translate([sqrt(pow(od/2-b-rad,2)-pow(w+rad,2)),-w-rad,0])cylinder(h+.2,r=rad,$fn=100);
        translate([sqrt(pow(id/2+b+rad,2)-pow(w+rad,2)),w,0])cube([od/2-b-rad-(id/2+b+rad),b,h+.2]);
        rotate([0,0,deg])translate([sqrt(pow(id/2+b+rad,2)-pow(w+rad,2)),-3*w,0])cube([od/2-b-rad-(id/2+b+rad),b,h+.2]);      
    
        intersection(){
            difference(){
                cylinder(h+.2,r=od/2-b,$fn=100);
                translate([0,0,-.1])cylinder(h+.4,r=id/2+b,$fn=100);
            }
            linear_extrude(h+.2)polygon([
                [0,0],
                [(id/2+b)*cos(atan((w+rad)/sqrt(pow(id/2+b+rad,2)-pow(w+rad,2)))),(id/2+b)*sin(atan((w+rad)/sqrt(pow(id/2+b+rad,2)-pow(w+rad,2))))],
                [(od/2-b)*cos(atan((w+rad)/sqrt(pow(od/2-b-rad,2)-pow(w+rad,2)))),(od/2-b)*sin(atan((w+rad)/sqrt(pow(od/2-b-rad,2)-pow(w+rad,2))))],
                [(od)/tan(deg/2),od],
                [(od/2-b)*cos(deg-atan((w+rad)/(od/2-b-rad))),(od/2-b)*sin(deg-atan((w+rad)/(od/2-b-rad)))],
                [(id/2+b)*cos(deg-atan((w+rad)/(id/2+b+rad))),(id/2+b)*sin(deg-atan((w+rad)/(id/2+b+rad)))]]);
        }
    }
}

module spin_windows(b,id,od,rad,h,n){
    deg = 360/n;    
    for (i = [0:n-1]){
        rotate([0,0,deg*i])window(b,id,od,rad,h,n,deg);
    }

}


/* Library included below to allow customizer functionality    
 *
 *    polyScrewThread_r1.scad    by aubenc @ Thingiverse
 *
 *Truncated to provide required support. Above module countersink_end is lifted and edited from hex_countersink_ends
 *
 * This script contains the library modules that can be used to generate
 * threaded rods, screws and nuts.
 *
 * http://www.thingiverse.com/thing:8796
 *
 * CC Public Domain
 */

module screw_thread(od,st,lf0,lt,rs,cs)
{
    or=od/2;
    ir=or-st/2*cos(lf0)/sin(lf0);
    pf=2*PI*or;
    sn=floor(pf/rs);
    lfxy=360/sn;
    ttn=round(lt/st+2); //From 1 to 2
    zt=st/sn;

    intersection()
    {
        if (cs >= -1)
        {
           thread_shape(cs,lt,or,ir,sn,st);
        }
        
        full_thread(ttn,st,sn,zt,lfxy,or,ir);
        
    }
}



module thread_shape(cs,lt,or,ir,sn,st)
{
    if ( cs == 0 )
    {
        cylinder(h=lt, r=or, $fn=sn, center=false);
    }
    else
    {
        union()
        {
            translate([0,0,st/2])
              cylinder(h=lt-st+0.005, r=or, $fn=sn, center=false);

            if ( cs == -1 || cs == 2 )
            {
                cylinder(h=st/2, r1=ir, r2=or, $fn=sn, center=false);
            }
            else
            {
                cylinder(h=st/2, r=or, $fn=sn, center=false);
            }

            translate([0,0,lt-st/2])
            if ( cs == 1 || cs == 2 )
            {
                  cylinder(h=st/2, r1=or, r2=ir, $fn=sn, center=false);
            }
            else
            {
                cylinder(h=st/2, r=or, $fn=sn, center=false);
            }
        }
    }
}

module full_thread(ttn,st,sn,zt,lfxy,or,ir)
{
    
  if(ir >= 0.2)
  {
        for(i=[0:ttn-1])
        {
            for(j=[0:sn-1]){
                pt = [  [0,                  0,                  i*st-st            ],
                        [ir*cos(j*lfxy),     ir*sin(j*lfxy),     i*st+j*zt-st       ],
                        [ir*cos((j+1)*lfxy), ir*sin((j+1)*lfxy), i*st+(j+1)*zt-st   ],
                        [0,                  0,                  i*st               ],
                        [or*cos(j*lfxy),     or*sin(j*lfxy),     i*st+j*zt-st/2     ],
                        [or*cos((j+1)*lfxy), or*sin((j+1)*lfxy), i*st+(j+1)*zt-st/2 ],
                        [ir*cos(j*lfxy),     ir*sin(j*lfxy),     i*st+j*zt          ],
                        [ir*cos((j+1)*lfxy), ir*sin((j+1)*lfxy), i*st+(j+1)*zt      ],
                        [0,                  0,                  i*st+st            ]];
            
                polyhedron(points=pt,
                        faces=[	[1,0,3],[1,3,6],[6,3,8],[1,6,4],
                                [0,1,2],[1,4,2],[2,4,5],[5,4,6],
                                [5,6,7],[7,6,8],[7,8,3],[0,2,3],
                                [3,2,7],[7,2,5]	]);
            }
        }
  }
  else
  {
    echo("Step Degrees too aggresive, the thread will not be made!!");
    echo("Try to increase the value for the degrees and/or...");
    echo(" decrease the pitch value and/or...");
    echo(" increase the outer diameter value.");
  }
}

module hex_countersink_ends(chg,cod,clf,crs,hg)
{
    /*translate([0,0,-0.1])
    cylinder(h=chg+0.01, 
             r1=cod/2, 
             r2=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             $fn=floor(cod*PI/crs), center=false);*/

    translate([0,0,hg-chg+0.1])
    cylinder(h=chg+0.01, 
             r1=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             r2=cod/2, 
             $fn=floor(cod*PI/crs), center=false);
}

// Pack efficiency ~66%