function OD_Type = OD_Ty_Fname(fname)

str0 = split(fname,'_');
OD_Ty = cell2mat(str0(contains(str0,'OS') | contains(str0,'OD')));

if strcmp(OD_Ty,'OD')
    OD_Type = 'Right';
elseif strcmp(OD_Ty,'OS')
    OD_Type = 'Left';
end