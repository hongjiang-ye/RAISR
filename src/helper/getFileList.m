function file_list = getFileList(input_file_list)
%REMOVEHIDDENFILES remove '.', '..', '.DS_Store' and directories
    
    file_list = input_file_list;
    file_list = file_list(cellfun(@(x) ~x, {file_list.isdir}));
    file_list = file_list(cellfun(@(str) str(1) ~= '.', {file_list.name}));

end

