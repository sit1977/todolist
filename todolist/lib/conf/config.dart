const String APPNAME = 'Todo list';
const String SERVERADDRESS = 'http://192.168.1.19:8000';
const Map<String, String> APIRoutes = {
  'todo-list': SERVERADDRESS + '/api/all-todolist',
  'todo-create': SERVERADDRESS + '/api/create-todolist',
  'todo-update': SERVERADDRESS + '/api/update-todolist/',
  'todo-delete': SERVERADDRESS + '/api/delete-todolist/'
};
