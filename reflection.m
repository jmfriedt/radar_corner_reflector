% see https://www.mdpi.com/2072-4292/11/8/988 (E. Trouve)
% see https://www.researchgate.net/profile/Xinjian-Shan-2/publication/257908428_The_selection_of_artificial_corner_reflectors_based_on_RCS_analysis/

% Characteristics of SAR backscatter amplitudes corresponding to the seasonal snow-depth variation at snow-buried cubic corner reflectors installed in Nagaoka, Japan
% https://ui.adsabs.harvard.edu/abs/2021AGUFM.C15F0854N/abstract

% Sensitivity analysis of backscatter amplitude at snow-buried corner reflectors using C-/L-band SARs
% https://ui.adsabs.harvard.edu/abs/2020AGUFMC005.0006N/abstract

nx=[1 0 0];     % corner reflector definition
ny=[0 1 0];
nz=[0 0 1];
epsilon=1e-5;   % uncertainty = 12.3 m wide antenna @ 1000 km : 12.3/1000e3
display=0;
phi=-30
snowcase=4
if (snowcase==1) p0=[1 0 0];  nd=[1 1 1];end % full of snow
if (snowcase==2) p0=[0 0 0.1];nd=[0 0 1];end % snow on the bottom
if (snowcase==3) p0=[0 0.1 0];nd=[0 1 0];end % snow on the side
if (snowcase==4) p0=[0 0.1 0];nd=[0.02 1 0.02];end % snow on the side
if (snowcase==5) p0=[0 0.1 0];nd=[0.02 1 0];end % snow on the side

if (snowcase>0)
  nd=nd/sqrt(dot(nd,nd));
  mu=sqrt(1.3);  % dielectric relative permittivity ratio to air=1
else
  mu=1.0;
end
m=1;
for theta=-195:1:-55
% for theta=-170   % TEST
  indiele=0;     % 1 : from air to dielectric ; 0 : from dielectric to air (inverses mu)
  theta
  close all
  % display reflector
  if (display==1)
    plot3([0 0 1 1 0],[0 1 1 0 0],[0 0 0 0 0])
    hold on
    plot3([0 0 0 0 0],[0 0 1 1 0],[0 1 1 0 0])
    plot3([0 0 1 1 0],[0 0 0 0 0],[0 1 1 0 0])
    if (mu!=1)
      if (snowcase==1) plot3([1 0 0 1],[0 1 0 0],[0 0 1 0]);end % full
      if (snowcase==2) plot3([0 0 1 1 0],[0 1 1 0 0],[0.1 0.1 0.1 0.1 0.1]);end % bottom
      if (snowcase==3) plot3([0 0 1 1 0],[0.1 0.1 0.1 0.1 0.1],[0 1 1 0 0]);end % side
    end
    axis([-.15 2 -.15 2 -.15 2])
    xlabel('x')
    ylabel('y')
    zlabel('z')
  end

  l0x=cosd(theta)*cosd(phi);
  l0y=sind(theta)*cosd(phi);
  l0z=sind(phi);
  success=0;
  
  % initial vector
  l=[l0x l0y l0z];
  l=l/sqrt(dot(l,l));
  linit=l
  xp=-10*l0x;
  yp=-10*l0y;
  zp=-10*l0z;
  a=cross(linit,[1 0 0]);
  b=cross(linit,[0 1 0]);
  for s=-3:.2:3
    for t=-3:.2:3
%  for s=0.1  % TEST
%    for t=0.1  % TEST
  % http://jongarvin.com/up/MCV4U/slides/vector_parametric_plane_handout.pdf
  %     Parametric Equations of a Plane
  % The parametric equations of a plane are x = xp + sxa + txb,
  % y = yp + sya + tyb and z = zp + sza + tzb, where
  % P(xp , yp , zp ) is a point on the plane, ~a = (xa, ya, za) and
  % ~b = (xb, yb, zb) are two non-collinear vectors, and s, t ∈ R.
      x0=xp+a(1)*s+b(1)*t;
      y0=yp+a(2)*s+b(2)*t;
      z0=zp+a(3)*s+b(3)*t;
      l0=[x0 y0 z0];        % l0=[1.32 1 1.12];
      % plot3(l0(1),l0(2),l0(3),'.')
      l=linit;
      do
        cont=0;
        l=l/sqrt(dot(l,l));          % incident vector normalization
% intersection of ray and plane defined by normal and one point
% https://www.scratchapixel.com/lessons/3d-basic-rendering/minimal-ray-tracer-rendering-simple-shapes/ray-plane-and-ray-disk-intersection.html
% plane X, Y, Z through (0,0,0)
        tx=-dot(l0,nx)/dot(nx,l);    % three possible intersections with 3 planes
        ty=-dot(l0,ny)/dot(ny,l);
        tz=-dot(l0,nz)/dot(nz,l);
% plane [1 1 1] through (0.5,0.5,0.5)
        if (snowcase>0)
          td=dot(p0-l0,nd)/dot(nd,l);
        else
          td=Inf; % no dielectric
        end

        if ((tx)<epsilon) tx=Inf;end % remove previous intersection point (t<epsilon)
        if ((ty)<epsilon) ty=Inf;end % remove backward solutions (t<0)
        if ((tz)<epsilon) tz=Inf;end
        if ((td)<epsilon) td=Inf;end
        % printf("tx %f ty %f tz %f td %f\n",tx,ty,tz,td);
        diele=0;
        if ((isinf(tx)==0) || (isinf(ty)==0) || (isinf(tz)==0) || (isinf(td)==0))
          if ((abs(tx)<=abs(ty)) && (abs(tx)<=abs(tz)) && (abs(tx)<abs(td))) 
             t=tx;n=nx;printf("X");end
          if ((abs(ty)<=abs(tx)) && (abs(ty)<=abs(tz)) && (abs(ty)<abs(td))) 
             t=ty;n=ny;printf("Y");end
          if ((abs(tz)<=abs(tx)) && (abs(tz)<=abs(ty)) && (abs(tz)<abs(td))) 
             t=tz;n=nz;printf("Z");end
          if ((abs(td)<=abs(tx)) && (abs(td)<=abs(ty)) && (abs(td)<abs(tz))) 
             t=td;n=nd;printf("D");diele=1;indiele=1-indiele;end
          inter=l0+l*t;
          if (((inter(1)>=-epsilon)&&(inter(1)<=1) &&
            (inter(2)>=-epsilon)&&(inter(2)<=1) &&
            (inter(3)>=-epsilon)&&(inter(3)<=1))) %  || (diele==1))
            cont=1;
            % for display 
            if (display==1)
               if (diele==1)
                  line([(l0)(1) inter(1)],[(l0)(2) inter(2)],[(l0)(3) inter(3)],'color','green')
               else
                  line([(l0)(1) inter(1)],[(l0)(2) inter(2)],[(l0)(3) inter(3)],'color','blue')
               end
            end
            if (diele==0) r=l-2*dot(l,n)*n;
            else 
               if (indiele==1)
                 r1=-sqrt(1-mu^2*(1-dot(n,l)^2))*n+mu*(l-dot(n,l)*n); % +/-sqrt solutions
                 r2=sqrt(1-mu^2*(1-dot(n,l)^2))*n+mu*(l-dot(n,l)*n);  % +/-sqrt solutions
               else
                 r1=-sqrt(1-(1/mu)^2*(1-dot(n,l)^2))*n+(1/mu)*(l-dot(n,l)*n); % +/-sqrt solutions
                 r2=sqrt(1-(1/mu)^2*(1-dot(n,l)^2))*n+(1/mu)*(l-dot(n,l)*n);  % +/-sqrt solutions
               end
               if (sum(imag(r1))!=0) cont=0; printf("reflection totale %d\n",indiele);
               else
                 if (dot(l,r1)>=dot(l,r2)) r=r1;
                 else r=r2;
                 end
               end
            end
            l=r;
            l0=inter;
          end
      % for debug line([(inter+r)(1) inter(1)],[(inter+r)(2) inter(2)], [(inter+r)(3) inter(3)],'color',[1 0 0])
        end
      until (cont==0);
      if (exist('r'))
         if (display==1)
%            line([(inter+r)(1) inter(1)],[(inter+r)(2) inter(2)], [(inter+r)(3) inter(3)],'color',[1 0 0])
         end
         reflangle=dot(r,linit)/sqrt(dot(r,r)*dot(linit,linit));
         if (abs(reflangle+1)<epsilon) 
           if ((inter(1)>=-epsilon)&&(inter(1)<=1) &&
             (inter(2)>=-epsilon)&&(inter(2)<=1) &&
             (inter(3)>=-epsilon)&&(inter(3)<=1))
              printf("success\n");
              if (display==0)
%                 line([(inter+r)(1) inter(1)],[(inter+r)(2) inter(2)], [(inter+r)(3) inter(3)],'color',[1 0 0])
              end
              success=success+1;
              if (display==1) refresh();end
           end 
         end
      end
    end
  end
  final(m)=success;
  m=m+1;
end

% refraction
% https://physics.stackexchange.com/questions/435512/snells-law-in-vector-form
% n=[1 1 1]
% n=[1 0 0];n=n/sqrt(dot(n,n))
% i=[1 1 0];i=i/sqrt(dot(i,i))
% mu=1.1
% t=sqrt(1-mu^2*(1-dot(n,i)^2))*n+mu*(i-dot(n,i)*n)
% line([0 i(1)],[0 i(2)])
% line([0 -t(1)],[0 -t(2)],'color','red')
% where mu=n1/n2
figure
plot([-195:1:-55],final)
xlabel('theta (deg)')
ylabel('reflected signal (a.u.)')
