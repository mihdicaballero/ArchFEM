function clipboard(data)
if ~ischar(data)
    data = mat2str(data);
end
data = regexprep(data, '\\','\\\\');
data = regexprep(data, '%','%%');
f = tempname;
h = fopen(f, 'w');
fprintf(h, data);
fclose(h);
system(['clip.exe < ' f]);
delete(f);
end
