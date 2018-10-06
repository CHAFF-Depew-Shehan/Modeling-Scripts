function angle  = findAngle( v1, v2, O )
%FINDANGLE Finds the angle between two vectors in 3D, and if the origin isn't
%(0,0,0), the vectors are adjusted accordingly 
%   v1 and v2 are the angles and O is the origin 

% Move vectors to origins reference frame
dv1 = v1 - O;
dv2 = v2 - O;
angle = acos(dot(dv1,dv2)/(norm(dv1)*norm(dv2)));
end

