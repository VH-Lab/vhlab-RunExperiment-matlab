function gene = mutate_gene( gene, param )
% MUTATE_GENE mutates one gene
%
%   GENE = MUTATE_GENE( GENE, PARAM )
%     mutates gene
%
%   GENE = MUTATE_GENE( GENE )
%     uses genetic_defaults as PARAM
%
%   see 'help geneticstimuli' for general information
%   2003, Alexander Heimel
%

if nargin<2
  param=genetic_defaults;
end

fields=fieldnames(gene);
field=fields{unidrnd( length(fields) )};
switch field
 case 'type' % new
   gene.type = param.types( unidrnd( length(param.types) ) );
 case 'position' % adjust
   gene.position.x = mod( gene.position.x-round(param.window(1)/2)+...
			unidrnd(param.window(1)), param.window(1) ) + 1;
   gene.position.y = mod( gene.position.y-round(param.window(2)/2)+...
			unidrnd(param.window(2)), param.window(2) ) + 1;
 case 'duration' % adjust
   gene.duration = gene.duration + unidrnd( round(param.duration/2))-...
       round(param.duration/4) ;
   gene.duration = min( param.duration-gene.onset+1, ...
			gene.duration);  % avoid going past window
   gene.duration = max( 1, gene.duration);  % avoid zero
 case 'onset' % adjust
  gene.onset = gene.onset + unidrnd( round(param.duration/2))-...
      floor(param.duration/4)-1 ;
  gene.onset = max( 1, gene.onset); % avoid zero
  gene.onset = min( param.duration-gene.duration+1, gene.onset); 
 case 'size' % new
  gene.size =  unidrnd( param.sizelimit );
 case 'contrast' % new
  gene.contrast =  param.contrastlimits(1)+...
      (param.contrastlimits(2)-param.contrastlimits(1))*rand(1);
 case 'color' % new
  color = param.colors{ unidrnd( length(param.colors) ) };
  gene.color=struct('r',color(1),'g',color(2),'b',color(3));
 case 'speed' % new
  speed = -param.speedlimits -1 + unidrnd( 2*param.speedlimits+1 );
  gene.speed=struct('x',speed(1),'y',speed(2));
 
 case 'orientation' % adjust
  gene.orientation = mod( gene.orientation - 90 + unidrnd(180), 360);
 case 'eccentricity' % new
  gene.eccentricity = param.eccentricitylimits(1)+...
      (param.eccentricitylimits(2)-param.eccentricitylimits(1))*rand(1);
 otherwise
  disp( 'warning! mutate_gene: field unknown' );
end
