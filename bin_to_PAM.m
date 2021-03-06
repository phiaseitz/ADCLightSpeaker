function pamvec = bin_to_PAM(binvec)
%If our vector has an odd length add an extra 0
if (mod(length(binvec),2)) == 1
    binvec = vertcat(binvec, 0);
end  

%Initialize our pam vector
pam = zeros(length(binvec)/2,1);

%iterate through the array two bits at a time and convert each set to a
%value from 0-3
for i = 1:2:length(binvec)-1
    if isequal(binvec(i:i+1),[0;1])
        pam((i+1)/2) = 5;
    elseif isequal(binvec(i:i+1), [1;1])
         pam((i+1)/2) = 10/3;
    elseif isequal(binvec(i:i+1), [1;0])
         pam((i+1)/2) = 5/3;
    else
         pam((i+1)/2) = 0;
    end
end

%Return everything but the 0 we used to initalize pam
pamvec = pam;
end