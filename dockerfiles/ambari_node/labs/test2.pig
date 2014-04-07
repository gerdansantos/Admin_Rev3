rmf test_output2
a = load '/user/root/hbase.jar';
b = foreach a generate $0;
store b into 'test_output2';
