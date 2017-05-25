
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', '.git', true, true);
Module['FS_createPath']('/.git', 'hooks', true, true);
Module['FS_createPath']('/.git', 'info', true, true);
Module['FS_createPath']('/.git', 'logs', true, true);
Module['FS_createPath']('/.git/logs', 'refs', true, true);
Module['FS_createPath']('/.git/logs/refs', 'heads', true, true);
Module['FS_createPath']('/.git/logs/refs', 'remotes', true, true);
Module['FS_createPath']('/.git/logs/refs/remotes', 'origin', true, true);
Module['FS_createPath']('/.git', 'objects', true, true);
Module['FS_createPath']('/.git/objects', '01', true, true);
Module['FS_createPath']('/.git/objects', '0e', true, true);
Module['FS_createPath']('/.git/objects', '12', true, true);
Module['FS_createPath']('/.git/objects', '13', true, true);
Module['FS_createPath']('/.git/objects', '17', true, true);
Module['FS_createPath']('/.git/objects', '18', true, true);
Module['FS_createPath']('/.git/objects', '1b', true, true);
Module['FS_createPath']('/.git/objects', '1e', true, true);
Module['FS_createPath']('/.git/objects', '21', true, true);
Module['FS_createPath']('/.git/objects', '26', true, true);
Module['FS_createPath']('/.git/objects', '28', true, true);
Module['FS_createPath']('/.git/objects', '2d', true, true);
Module['FS_createPath']('/.git/objects', '2f', true, true);
Module['FS_createPath']('/.git/objects', '36', true, true);
Module['FS_createPath']('/.git/objects', '39', true, true);
Module['FS_createPath']('/.git/objects', '4b', true, true);
Module['FS_createPath']('/.git/objects', '4d', true, true);
Module['FS_createPath']('/.git/objects', '54', true, true);
Module['FS_createPath']('/.git/objects', '56', true, true);
Module['FS_createPath']('/.git/objects', '64', true, true);
Module['FS_createPath']('/.git/objects', '65', true, true);
Module['FS_createPath']('/.git/objects', '67', true, true);
Module['FS_createPath']('/.git/objects', '71', true, true);
Module['FS_createPath']('/.git/objects', '77', true, true);
Module['FS_createPath']('/.git/objects', '78', true, true);
Module['FS_createPath']('/.git/objects', '79', true, true);
Module['FS_createPath']('/.git/objects', '7d', true, true);
Module['FS_createPath']('/.git/objects', '8c', true, true);
Module['FS_createPath']('/.git/objects', '94', true, true);
Module['FS_createPath']('/.git/objects', '97', true, true);
Module['FS_createPath']('/.git/objects', '9b', true, true);
Module['FS_createPath']('/.git/objects', 'a4', true, true);
Module['FS_createPath']('/.git/objects', 'a6', true, true);
Module['FS_createPath']('/.git/objects', 'a7', true, true);
Module['FS_createPath']('/.git/objects', 'aa', true, true);
Module['FS_createPath']('/.git/objects', 'ae', true, true);
Module['FS_createPath']('/.git/objects', 'b1', true, true);
Module['FS_createPath']('/.git/objects', 'b5', true, true);
Module['FS_createPath']('/.git/objects', 'b6', true, true);
Module['FS_createPath']('/.git/objects', 'b7', true, true);
Module['FS_createPath']('/.git/objects', 'ba', true, true);
Module['FS_createPath']('/.git/objects', 'be', true, true);
Module['FS_createPath']('/.git/objects', 'bf', true, true);
Module['FS_createPath']('/.git/objects', 'c5', true, true);
Module['FS_createPath']('/.git/objects', 'ca', true, true);
Module['FS_createPath']('/.git/objects', 'd2', true, true);
Module['FS_createPath']('/.git/objects', 'd4', true, true);
Module['FS_createPath']('/.git/objects', 'd8', true, true);
Module['FS_createPath']('/.git/objects', 'dc', true, true);
Module['FS_createPath']('/.git/objects', 'dd', true, true);
Module['FS_createPath']('/.git/objects', 'e0', true, true);
Module['FS_createPath']('/.git/objects', 'e4', true, true);
Module['FS_createPath']('/.git/objects', 'e5', true, true);
Module['FS_createPath']('/.git/objects', 'ef', true, true);
Module['FS_createPath']('/.git/objects', 'f0', true, true);
Module['FS_createPath']('/.git/objects', 'f7', true, true);
Module['FS_createPath']('/.git/objects', 'fe', true, true);
Module['FS_createPath']('/.git', 'refs', true, true);
Module['FS_createPath']('/.git/refs', 'heads', true, true);
Module['FS_createPath']('/.git/refs', 'remotes', true, true);
Module['FS_createPath']('/.git/refs/remotes', 'origin', true, true);
Module['FS_createPath']('/', 'dependencies', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_game.data');

    };
    Module['addRunDependency']('datafile_game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 8196, "filename": "/.DS_Store"}, {"audio": 0, "start": 8196, "crunched": 0, "end": 12602, "filename": "/main.lua"}, {"audio": 0, "start": 12602, "crunched": 0, "end": 12689, "filename": "/.git/COMMIT_EDITMSG"}, {"audio": 0, "start": 12689, "crunched": 0, "end": 13009, "filename": "/.git/config"}, {"audio": 0, "start": 13009, "crunched": 0, "end": 13082, "filename": "/.git/description"}, {"audio": 0, "start": 13082, "crunched": 0, "end": 13190, "filename": "/.git/FETCH_HEAD"}, {"audio": 0, "start": 13190, "crunched": 0, "end": 13213, "filename": "/.git/HEAD"}, {"audio": 0, "start": 13213, "crunched": 0, "end": 13475, "filename": "/.git/index"}, {"audio": 0, "start": 13475, "crunched": 0, "end": 13516, "filename": "/.git/ORIG_HEAD"}, {"audio": 0, "start": 13516, "crunched": 0, "end": 13994, "filename": "/.git/hooks/applypatch-msg.sample"}, {"audio": 0, "start": 13994, "crunched": 0, "end": 14890, "filename": "/.git/hooks/commit-msg.sample"}, {"audio": 0, "start": 14890, "crunched": 0, "end": 15079, "filename": "/.git/hooks/post-update.sample"}, {"audio": 0, "start": 15079, "crunched": 0, "end": 15503, "filename": "/.git/hooks/pre-applypatch.sample"}, {"audio": 0, "start": 15503, "crunched": 0, "end": 17145, "filename": "/.git/hooks/pre-commit.sample"}, {"audio": 0, "start": 17145, "crunched": 0, "end": 18493, "filename": "/.git/hooks/pre-push.sample"}, {"audio": 0, "start": 18493, "crunched": 0, "end": 23444, "filename": "/.git/hooks/pre-rebase.sample"}, {"audio": 0, "start": 23444, "crunched": 0, "end": 23988, "filename": "/.git/hooks/pre-receive.sample"}, {"audio": 0, "start": 23988, "crunched": 0, "end": 25227, "filename": "/.git/hooks/prepare-commit-msg.sample"}, {"audio": 0, "start": 25227, "crunched": 0, "end": 28837, "filename": "/.git/hooks/update.sample"}, {"audio": 0, "start": 28837, "crunched": 0, "end": 29077, "filename": "/.git/info/exclude"}, {"audio": 0, "start": 29077, "crunched": 0, "end": 32396, "filename": "/.git/logs/HEAD"}, {"audio": 0, "start": 32396, "crunched": 0, "end": 32572, "filename": "/.git/logs/refs/stash"}, {"audio": 0, "start": 32572, "crunched": 0, "end": 35733, "filename": "/.git/logs/refs/heads/master"}, {"audio": 0, "start": 35733, "crunched": 0, "end": 38451, "filename": "/.git/logs/refs/remotes/origin/master"}, {"audio": 0, "start": 38451, "crunched": 0, "end": 38615, "filename": "/.git/objects/01/47e4d5c59dbd64ce08a9b6caff682aceb1eebe"}, {"audio": 0, "start": 38615, "crunched": 0, "end": 38793, "filename": "/.git/objects/0e/5cce3c6cb10c7e62254f46ac3248b6019e59b5"}, {"audio": 0, "start": 38793, "crunched": 0, "end": 38916, "filename": "/.git/objects/12/cc061f6784b176f49fa32bea82bda7fcab12ae"}, {"audio": 0, "start": 38916, "crunched": 0, "end": 39082, "filename": "/.git/objects/13/faf1b709ea46d30408dfdd2f198423b0c26c18"}, {"audio": 0, "start": 39082, "crunched": 0, "end": 39271, "filename": "/.git/objects/17/a067daa24cb1ebeded94e770ca61abe98d580e"}, {"audio": 0, "start": 39271, "crunched": 0, "end": 39356, "filename": "/.git/objects/18/59ce9565dc3bfed0fe22e2cd845061e31d5d14"}, {"audio": 0, "start": 39356, "crunched": 0, "end": 39479, "filename": "/.git/objects/1b/6eff25b595b0b64ebef1f39202214bb85f49b2"}, {"audio": 0, "start": 39479, "crunched": 0, "end": 39643, "filename": "/.git/objects/1e/713f67a699fcfce751c74fbf6d17af63dfebc4"}, {"audio": 0, "start": 39643, "crunched": 0, "end": 39816, "filename": "/.git/objects/21/a7b5bbaaefa7b920399d6281f94382b19004ec"}, {"audio": 0, "start": 39816, "crunched": 0, "end": 39907, "filename": "/.git/objects/26/2a327c06f06d22e03045e470233c1f1ed92c45"}, {"audio": 0, "start": 39907, "crunched": 0, "end": 41851, "filename": "/.git/objects/28/c9ab064008131665b70409940aeb9144664636"}, {"audio": 0, "start": 41851, "crunched": 0, "end": 43422, "filename": "/.git/objects/2d/6d0d85d1457732360a0d4bd11d7eb82cb6c140"}, {"audio": 0, "start": 43422, "crunched": 0, "end": 43586, "filename": "/.git/objects/2d/86a5649e5674dff1ab5642a776be1dc765d8f0"}, {"audio": 0, "start": 43586, "crunched": 0, "end": 43752, "filename": "/.git/objects/2f/fd64f5627f18f72b4ccfb1ed1a3303ca2a51c4"}, {"audio": 0, "start": 43752, "crunched": 0, "end": 43921, "filename": "/.git/objects/36/c703956490948de3f7033588ec99d39d98b2b0"}, {"audio": 0, "start": 43921, "crunched": 0, "end": 44012, "filename": "/.git/objects/39/c84055e20beae2742575035dfcc9fdc0c852cd"}, {"audio": 0, "start": 44012, "crunched": 0, "end": 44027, "filename": "/.git/objects/4b/825dc642cb6eb9a060e54bf8d69288fbee4904"}, {"audio": 0, "start": 44027, "crunched": 0, "end": 45631, "filename": "/.git/objects/4d/12f16df43a2ab8d646610217ada8798d37334f"}, {"audio": 0, "start": 45631, "crunched": 0, "end": 45755, "filename": "/.git/objects/4d/d43498274ad721b86ee1a6dc91b2c3912bff7c"}, {"audio": 0, "start": 45755, "crunched": 0, "end": 47356, "filename": "/.git/objects/54/ad22b0c53c23dd25ee88a32f91c1710d5d799e"}, {"audio": 0, "start": 47356, "crunched": 0, "end": 54689, "filename": "/.git/objects/56/26d4ff4edfe444ecba14da32b04985023fb0b2"}, {"audio": 0, "start": 54689, "crunched": 0, "end": 56296, "filename": "/.git/objects/64/26db2ebdd627587955b3edb1d39b37bf519f45"}, {"audio": 0, "start": 56296, "crunched": 0, "end": 56419, "filename": "/.git/objects/65/f78c9d03f79d18a65dd1158d7c26df0a1f83c1"}, {"audio": 0, "start": 56419, "crunched": 0, "end": 57988, "filename": "/.git/objects/67/02f0fad6d82c5290399d577b5471659ca96e62"}, {"audio": 0, "start": 57988, "crunched": 0, "end": 58074, "filename": "/.git/objects/71/bdc65f900b5d8dc5782058615ca8462a81c0cc"}, {"audio": 0, "start": 58074, "crunched": 0, "end": 59672, "filename": "/.git/objects/77/79483d80c67f97b2ccc10a30cb9d342b64c70d"}, {"audio": 0, "start": 59672, "crunched": 0, "end": 60881, "filename": "/.git/objects/77/b583689e04a1132a2ecc839dbcba8ed7de1bb7"}, {"audio": 0, "start": 60881, "crunched": 0, "end": 61100, "filename": "/.git/objects/78/552b5eca35bc03415f4f998f108a2c06d0428b"}, {"audio": 0, "start": 61100, "crunched": 0, "end": 61196, "filename": "/.git/objects/79/3304db257e52fc7c9d4e135d3c94091e359c93"}, {"audio": 0, "start": 61196, "crunched": 0, "end": 61293, "filename": "/.git/objects/79/6769b3e7dcaadbfca6233fd756888b269018a1"}, {"audio": 0, "start": 61293, "crunched": 0, "end": 61384, "filename": "/.git/objects/7d/460ee65bd161d6a29a5b20ddfd44d3070d8581"}, {"audio": 0, "start": 61384, "crunched": 0, "end": 62221, "filename": "/.git/objects/8c/97620f12e46f1a6034b65680f81e815746cb66"}, {"audio": 0, "start": 62221, "crunched": 0, "end": 62383, "filename": "/.git/objects/94/3cf16d648c157eb7c019bfe9f45c6fc665ace7"}, {"audio": 0, "start": 62383, "crunched": 0, "end": 62465, "filename": "/.git/objects/97/4fda92471de79de1b7187f96ba4df4aab5183b"}, {"audio": 0, "start": 62465, "crunched": 0, "end": 64252, "filename": "/.git/objects/97/6c977658c2b4bcc096b4737b4d2e55a2d322f6"}, {"audio": 0, "start": 64252, "crunched": 0, "end": 64375, "filename": "/.git/objects/97/842e4e46247378907bfacada965c2ba708ccc6"}, {"audio": 0, "start": 64375, "crunched": 0, "end": 64498, "filename": "/.git/objects/9b/5a2d6c16559a8bb48d3a184173357a776f5789"}, {"audio": 0, "start": 64498, "crunched": 0, "end": 64589, "filename": "/.git/objects/a4/d45a40a369b727d61bc6526925c6512968b184"}, {"audio": 0, "start": 64589, "crunched": 0, "end": 64797, "filename": "/.git/objects/a6/c9eccb6b02df0982118d88d16186998f503637"}, {"audio": 0, "start": 64797, "crunched": 0, "end": 64920, "filename": "/.git/objects/a7/4e05b30432a48f0aaf46b85baeb23bab2f6dd4"}, {"audio": 0, "start": 64920, "crunched": 0, "end": 67250, "filename": "/.git/objects/aa/49465fd14bf101d8fc4b35d8490c0c29745437"}, {"audio": 0, "start": 67250, "crunched": 0, "end": 67341, "filename": "/.git/objects/ae/2f7caba6be992c56ffd25faaceb4da761a7932"}, {"audio": 0, "start": 67341, "crunched": 0, "end": 68936, "filename": "/.git/objects/b1/d7b90ba9009b1f1daa31cea3334ea263974f87"}, {"audio": 0, "start": 68936, "crunched": 0, "end": 69059, "filename": "/.git/objects/b5/13ddff24f265ac5e431aaf15088025f2f71c22"}, {"audio": 0, "start": 69059, "crunched": 0, "end": 70625, "filename": "/.git/objects/b6/972ab87e91b08f5f3bff9d09ac4e1a106b3fbc"}, {"audio": 0, "start": 70625, "crunched": 0, "end": 70667, "filename": "/.git/objects/b7/2b08937e9ca567a355ac9e9017e746b6f28ba5"}, {"audio": 0, "start": 70667, "crunched": 0, "end": 70768, "filename": "/.git/objects/ba/10e7d1f15a25b3cc3069ae4d3f02393c4c393b"}, {"audio": 0, "start": 70768, "crunched": 0, "end": 70978, "filename": "/.git/objects/ba/9da282afa9286f0ec28121fca797041f439529"}, {"audio": 0, "start": 70978, "crunched": 0, "end": 71031, "filename": "/.git/objects/be/1c00f38b8bf049852a4e3a23eb3d692ff21d02"}, {"audio": 0, "start": 71031, "crunched": 0, "end": 71117, "filename": "/.git/objects/bf/9fed178ded5e4dcc5d5ef6950c197003e6c96f"}, {"audio": 0, "start": 71117, "crunched": 0, "end": 71304, "filename": "/.git/objects/c5/5acc0d3482d070ecf5c7ba6f0f583f14c9d279"}, {"audio": 0, "start": 71304, "crunched": 0, "end": 71353, "filename": "/.git/objects/ca/a061675e2d9fceac7a59eeb95d247d6e924e55"}, {"audio": 0, "start": 71353, "crunched": 0, "end": 71485, "filename": "/.git/objects/d2/1c81d7774e48854c52d5039e7163178e2469b3"}, {"audio": 0, "start": 71485, "crunched": 0, "end": 71567, "filename": "/.git/objects/d2/740da4364e956bca87015454c643ee4433a21b"}, {"audio": 0, "start": 71567, "crunched": 0, "end": 71742, "filename": "/.git/objects/d4/02c300a716685bd9d48553b74f5f992be38888"}, {"audio": 0, "start": 71742, "crunched": 0, "end": 71865, "filename": "/.git/objects/d4/11d7cf00f0ee195b3301626449bf0d80a481bc"}, {"audio": 0, "start": 71865, "crunched": 0, "end": 72052, "filename": "/.git/objects/d8/0c198cbaa2fb7fff2bc785e49d1db2126b2ae1"}, {"audio": 0, "start": 72052, "crunched": 0, "end": 72218, "filename": "/.git/objects/dc/2c75ac4b962dc6df93f8e1f18e586e0ba368e3"}, {"audio": 0, "start": 72218, "crunched": 0, "end": 72383, "filename": "/.git/objects/dd/07ee7cbf0cc4c0f9e078e2028fdbd3da4b8182"}, {"audio": 0, "start": 72383, "crunched": 0, "end": 73986, "filename": "/.git/objects/e0/594c0f9888368e9dabec64a8a5738173c117e5"}, {"audio": 0, "start": 73986, "crunched": 0, "end": 74785, "filename": "/.git/objects/e4/1c558409d3a86223717a143b2de692e4bff54b"}, {"audio": 0, "start": 74785, "crunched": 0, "end": 79668, "filename": "/.git/objects/e5/c64b46b0b59b1aca7ad0ecb1cc81f165f4fd86"}, {"audio": 0, "start": 79668, "crunched": 0, "end": 79833, "filename": "/.git/objects/ef/00c30c31469bec24222baadd2591150c0edfcf"}, {"audio": 0, "start": 79833, "crunched": 0, "end": 81177, "filename": "/.git/objects/f0/8f70fb70ec55fa8e6bfd84e9f7a9ea7f661268"}, {"audio": 0, "start": 81177, "crunched": 0, "end": 81268, "filename": "/.git/objects/f7/613645165e4f541f14a3fc56be229cfde28396"}, {"audio": 0, "start": 81268, "crunched": 0, "end": 81391, "filename": "/.git/objects/fe/a68cb7651bef49c53e5ddaf35f326149bcbd39"}, {"audio": 0, "start": 81391, "crunched": 0, "end": 81432, "filename": "/.git/refs/stash"}, {"audio": 0, "start": 81432, "crunched": 0, "end": 81473, "filename": "/.git/refs/heads/master"}, {"audio": 0, "start": 81473, "crunched": 0, "end": 81514, "filename": "/.git/refs/remotes/origin/master"}, {"audio": 0, "start": 81514, "crunched": 0, "end": 102973, "filename": "/dependencies/bump.lua"}], "remote_package_size": 102973, "package_uuid": "d3f1ee8c-8e32-4955-9ffe-ee9d9d13a5f7"});

})();
