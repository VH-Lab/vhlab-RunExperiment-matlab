function addtodb(g,db)

f = fieldnames(g);

for i=1:length(f),
  if length(f{i})>4,
    if strcmp(f{i}(1:4),'cell'),
      r = input(['Add ' f{i} ' (y/n)?'],'s');
      if r=='y'|r=='Y',
         eval([f{i} ' = g.' f{i} ';']);
         if exist(db)==2,
           eval(['save ' db ' ' f{i} ' -append -mat']);
         else, eval(['save ' db ' ' f{i} ' -mat']);
         end;
      end;
    end;
  end;
end;
