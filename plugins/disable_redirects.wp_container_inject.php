<?php
/*
Plugin Name: Disable Canonical URL Redirection
Description: Disables the "Canonical URL Redirect" features of WordPress 2.3 and above.
Version: 1.0 
Author: Andrei Volkov
Author URI: http://upwork.link
*/ 
remove_filter('template_redirect', 'redirect_canonical');
