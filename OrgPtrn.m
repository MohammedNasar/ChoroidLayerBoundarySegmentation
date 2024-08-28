function ptrn = OrgPtrn(orgPath)

lst = dir(strcat(orgPath,'*.jpg'));

fn = lst(1).name;
str0 = split(fn,'.');
ptrn = str0{1}(1:end-4);
