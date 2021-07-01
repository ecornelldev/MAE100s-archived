
function folderDir = fileFinder(currentDirectory, filename)
   dircontent = dir(fullfile(currentDirectory, '*'));
   if any(strcmpi({dircontent(~[dircontent.isdir]).name}, filename))
        %file is found in directory
        folderDir = currentDirectory;
   else
        %look in subdirectories
        for subdir = dircontent([dircontent.isdir] & ~ismember({dircontent.name}, {'.', '..'}))'
            folderDir = fileFinder(fullfile(currentDirectory, subdir.name), filename);
            if ~isempty(folderDir)
                %found in a directory
                return;
            end
        end
        %looked in all subdirectories and not found
        folderDir = ''; %return empty
   end
end