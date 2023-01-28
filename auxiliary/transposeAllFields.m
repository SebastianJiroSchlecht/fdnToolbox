function s = transposeAllFields(s)
% transpose all field matrices

s = structfun(@transpose,s,'UniformOutput',false); 