Test case 1: Nginx gzip is already enabled

```shell
# ./34-nginx-options.sh
1) Global change to Nginx
2) Individual site
3) Cancel
#? 1
1) Enable/Disable gzip
2) Cancel
#? 1
INFO: Nginx gzip is already enabled.
INFO: No action required. Exiting...
```

---

Test case 2: Nginx gzip is enabled and nginx is reloaded
```shell
# ./34-nginx-options.sh
1) Global change to Nginx
2) Individual site
3) Cancel
#? 1
1) Enable/Disable gzip
2) Cancel
#? 1
Would you like to enable gzip?
1) Yes
2) No
3) Cancel
#? 1
INFO: Enabling gzip in /etc/nginx/nginx.conf
Reload Nginx now?
1) Yes
2) No
3) Cancel
#? 1
Successfully reloaded nginx
```

---

Test case 3: Operation canceled. Exit script.
```shell
# ./34-nginx-options.sh
1) Global change to Nginx
2) Individual site
3) Cancel
#? 3
INFO: Canceling...
```

---

Test case 4: HTTP/2 is already enabled for webdemo1.valiyev.com
```shell
1) Global change to Nginx
2) Individual site
3) Cancel
#? 2
1) webdemo1.valiyev.com
2) webdemo2.valiyev.com
Select a site: 1
INFO: Selected: webdemo1.valiyev.com
Select a site operation
1) Enable/Disable HTTP/2
2) Cancel
Select a site: 1
INFO: Selected: webdemo1.valiyev.com
INFO: HTTP2 is already enabled.
INFO: No action required. Exiting...
```

---

Test case 4: Enable HTTP/2 for webdemo1.valiyev.com and reload nginx
```shell
# ./34-nginx-options.sh
1) Global change to Nginx
2) Individual site
3) Cancel
#? 2
1) webdemo1.valiyev.com
2) webdemo2.valiyev.com
Select a site: 1
INFO: Selected: webdemo1.valiyev.com
Select a site operation
1) Enable/Disable HTTP/2
2) Cancel
Select a site: 1
INFO: Selected: webdemo1.valiyev.com
Would you like to enable HTTP2 for webdemo1.valiyev.com?
1) Yes
2) No
3) Cancel
Select a site: 1
INFO: Enabling HTTP2 for webdemo1.valiyev.com
Reload Nginx now?
1) Yes
2) No
3) Cancel
Select a site: 1
Successfully reloaded nginx
```

