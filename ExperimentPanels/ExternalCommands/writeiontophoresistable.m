function b = writeiontophoresistable(pathname, iontTable)

b = 0;

fidI = fopen([pathname 'iontophoresis_instruction.txt'],'w');
if ~isempty(fidI),
	for i=1:size(iontTable,1),
		fprintf(fidI,['%d,%4.4f,%4.4f,%4.4f'],iontTable(i,1),iontTable(i,2),iontTable(i,3),1000*iontTable(i,4));
		fwrite(fidI,13,'char'); fwrite(fidI,10,'char');
	end;
	fclose(fidI);
    b = 1;
end;
