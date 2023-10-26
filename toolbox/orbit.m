function [orbit] = orbit(a,e,inc,OM,om)
    orbit.a=a;
    orbit.e=e;
    orbit.inc=inc;
    orbit.OM=OM;
    orbit.om=om;
    orbit.rp=orbit.a*(1-orbit.e);
    orbit.ra=orbit.a*(1+orbit.e);
end