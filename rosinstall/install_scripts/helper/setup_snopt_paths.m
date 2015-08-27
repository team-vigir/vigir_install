root_dir = getenv('VIGIR_ROOT_DIR');

if ( isempty(root_dir) )
  root_dir = getenv('THOR_ROOT');
end

if ( isempty(root_dir) )
  warning('Neither VIGIR_ROOT_DIR nor THOR_ROOT set: Not setting SNOPT paths');
  return;
end

snopt_base_path = [root_dir '/snopt7'];

if ( ~exist(snopt_base_path,'dir') )
  warning('There does not seem to be a SNOPT installation in your ROOT_DIR. Not setting SNOPT paths');
  return;
end

snopt_paths = [snopt_base_path '/matlab:', ...
     snopt_base_path '/matlab/examples:', ...
     snopt_base_path '/matlab/examples/t1diet:', ...
     snopt_base_path '/matlab/examples/sntoy:', ...
     snopt_base_path '/matlab/examples/snmain:', ...
     snopt_base_path '/matlab/examples/hsmain:', ...
     snopt_base_path '/matlab/examples/sncute:'];
 
 addpath(snopt_paths)
 
 clear root_dir
 clear snopt_base_path
 clear snopt_paths
