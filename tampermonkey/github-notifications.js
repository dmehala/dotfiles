// ==UserScript==
// @name         GitHub Notification Filter
// @namespace    https://github.com/
// @version      1.1
// @description  Filter out GitHub notifications from repos I don't care but the company believe I should care
// @author       dmehala && ChatGPT 5
// @match        https://github.com/notifications*
// @grant        none
// ==/UserScript==

(function () {
    'use strict';

    const ignoreRepos = [
        'DataDog/system-tests',
        'DataDog/dd-trace-js',
        'DataDog/injector-dev',
        'DataDog/datadog-agent',
    ];

    function filterNotificationGroups() {
        const groups = document.querySelectorAll('.js-notifications-group');

        groups.forEach(group => {
            const repoLink = group.querySelector('a.Link--primary');
            const repo = repoLink.innerHTML

            if (ignoreRepos.includes(repo)) {
                group.style.display = 'none';
            } else {
                group.style.display = '';
            }
        });
    }

    if(document.readyState == 'complete') {
        filterNotificationGroups();
    } else {
        window.addEventListener('load', filterNotificationGroups);
    }
})();
