function [DeltaV1, DeltaV2, Deltat, transfer_orbit] = bitangentTransfer(orbit_i, orbit_f, type, mi)
% 
% Bitangent transfer for elliptic orbits
% 
% [DeltaV1, DeltaV2, Deltat] = bitangentTransfer(orbit_i, orbit_f, type, mi)
% 
% Input arguments:
% orbit_i       initial orbit
% orbit_f       final orbit
% type          maneuver type
% (mi)          gravitational parameter     [km^3/s^2]
% 
% Output arguments:
% DeltaV1       1st maneuver impulse        [km/s]
% DeltaV2       2nd maneuver impulse        [km/s]
% Deltat        maneuver time               [s]

if nargin == 3
    mi = 398600;
end

if abs(orbit_i.inc - orbit_f.inc) > eps * 10^6
    error("Orbite non sullo stesso piano");
end

if abs(orbit_i.OM - orbit_f.OM) > eps * 10^6
    error("Orbite non sullo stesso piano");
end

if (abs(orbit_i.om - orbit_f.om) > eps * 10^6) && (abs(orbit_i.om - orbit_f.om) > pi + eps*10^6)
    error("Orbite con argomenti del pericentro non compatibili");
end

switch type
    case "pa" % 1)
        % Pericentro - Apocentro:
        rp_i = orbit_i.rp;
        rp_t = rp_i;
        ra_f = orbit_f.ra;
        ra_t = ra_f;

        a_t = (ra_t + rp_t) / 2;
        a_i = orbit_i.a;
        a_f = orbit_f.a;

        vp_t = sqrt(mi*(2/rp_t-1/a_t));
        vp_i = sqrt(mi*(2/rp_i-1/a_i));
        DeltaV1 = vp_t - vp_i;
        va_f = sqrt(mi*(2/ra_f-1/a_f));
        va_t = sqrt(mi*(2/ra_t-1/a_t));
        DeltaV2 = va_f - va_t;
        transfer_orbit = orbit(a_t, (ra_t - rp_t)/(ra_t + rp_t), orbit_i.inc, orbit_i.OM, orbit_i.om, 0);

    case "ap" % 2)
        % Apocentro - Pericentro:
        ra_i = orbit_i.ra;
        ra_t = ra_i;
        rp_f = orbit_f.rp;
        rp_t = rp_f;

        a_t = (ra_t + rp_t) / 2;
        a_i = orbit_i.a;
        a_f = orbit_f.a;

        va_t = sqrt(mi*(2/ra_t-1/a_t));
        va_i = sqrt(mi*(2/ra_i-1/a_i));
        DeltaV1 = va_t - va_i;
        vp_f = sqrt(mi*(2/rp_f-1/a_f));
        vp_t = sqrt(mi*(2/rp_t-1/a_t));
        DeltaV2 = vp_f - vp_t;
        transfer_orbit = orbit(a_t, (ra_t - rp_t)/(ra_t + rp_t), orbit_i.inc, orbit_i.OM, orbit_i.om, pi);

    case "pp" % 3)
        % Pericentro - Pericentro:
        rp_i = orbit_i.rp;
        rp_t = rp_i;
        rp_f = orbit_f.rp;
        ra_t = rp_f;

        a_t = (ra_t + rp_t) / 2;
        a_i = orbit_i.a;
        a_f = orbit_f.a;

        vp_t = sqrt(mi*(2/rp_t-1/a_t));
        vp_i = sqrt(mi*(2/rp_i-1/a_i));
        DeltaV1 = vp_t - vp_i;
        vp_f = sqrt(mi*(2/rp_f-1/a_f));
        va_t = sqrt(mi*(2/ra_t-1/a_t));
        DeltaV2 = vp_f - va_t;
        transfer_orbit = orbit(a_t, (ra_t - rp_t)/(ra_t + rp_t), orbit_i.inc, orbit_i.OM, orbit_i.om, 0);

    case "aa" % 4)
        % Apocentro - Apocentro:
        ra_i = orbit_i.ra;
        rp_t = ra_i;
        ra_f = orbit_f.ra;
        ra_t = ra_f;

        a_t = (ra_t + rp_t) / 2;
        a_i = orbit_i.a;
        a_f = orbit_f.a;

        vp_t = sqrt(mi*(2/rp_t-1/a_t));
        va_i = sqrt(mi*(2/ra_i-1/a_i));
        DeltaV1 = vp_t - va_i;
        va_f = sqrt(mi*(2/ra_f-1/a_f));
        va_t = sqrt(mi*(2/ra_t-1/a_t));
        DeltaV2 = va_f - va_t;
        transfer_orbit = orbit(a_t, (ra_t - rp_t)/(ra_t + rp_t), orbit_i.inc, orbit_i.OM, orbit_f.om, pi);
end

Deltat = pi*sqrt(a_t^3 / mi);


