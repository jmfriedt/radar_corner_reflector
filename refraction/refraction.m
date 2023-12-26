ti=[30:50];       % incoming angle range with respect to corner reflector bottom plate
p=3.8             % dielectric slab angle (degrees)
subplot(211)
for eps=[1.5 2.5] % dielectric layer relative permittivity
  n=sqrt(eps)     % optical index = sqrt(relative permittivity)
  t1=asind(1/n*sind(90-p-ti));
  t2=asind(n*sind(t1+2*p));
  to=90+p-t2
  k=find(imag(to)!=0);
  to(k)=NaN;
  plot(ti,to-ti)
  hold on
end
xlabel('incoming beam angle (deg)')
ylabel('beam deviation (deg)')
legend('permittivity=1.5','permittivity=2.5','location','southeast')
