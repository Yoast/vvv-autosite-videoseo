printf "\nCommencing Setup for VideoSEO Dev environment\n"

# If we deleted htdocs, let's just start over.
if [ ! -d htdocs ]; then

	printf "Creating directory htdocs for VideoSEO Dev...\n"
	mkdir htdocs
	cd htdocs

	# **
	# Database
	# **

	# Create the database over again.
	printf "(Re-)Creating database 'videoseo_dev'...\n"
	mysql -u root --password=root -e "DROP DATABASE IF EXISTS \`videoseo_dev\`"
	mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS \`videoseo_dev\`"
	mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON \`videoseo_dev\`.* TO wp@localhost IDENTIFIED BY 'wp';"

	# **
	# WordPress
	# **

	# Download WordPress
	printf "Downloading WordPress in htdocs...\n"
	wp core download --allow-root

	# Install WordPress.
	printf "Creating wp-config in htdocs...\n"
	wp core config --dbname="videoseo_dev" --dbuser=wp --dbpass=wp --dbhost="localhost" --allow-root --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_DISPLAY', true );
define( 'SCRIPT_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
//define( 'SAVEQUERIES', true );
PHP

	# Install into DB
	printf "Installing WordPress...\n"
	wp core install --url=videoseo.dev --title="VideoSEO Dev environment" --admin_user=admin --admin_password=password --admin_email=changme@changeme.com --allow-root

	# **
	# Cloning Yoast SEO from GH.
	# **

	printf 'Cloning Yoast SEO & running composer...\n'
	cd /srv/www/videoseo/htdocs/wp-content/plugins
	- git clone https://github.com/Yoast/wordpress-seo.git /tmp/wordpress/src/wp-content/plugins/wordpress-seo
	cd /srv/www/videoseo/htdocs/wp-content/plugins/wordpress-seo
	composer selfupdate 1.0.0 --no-interaction
	composer install --no-interaction
	cd /srv/www/videoseo/htdocs/


	# **
	# Installing VideoSEO and dependencies via Composer.
	# **

	printf 'Cloning VideoSEO & running composer...\n'
	cd /srv/www/videoseo/htdocs/wp-content/plugins
	- git clone https://github.com/Yoast/wpseo-video.git /tmp/wordpress/src/wp-content/plugins/wpseo-video
	cd /srv/www/videoseo/htdocs/wp-content/plugins/wpseo-video
	composer selfupdate 1.0.0 --no-interaction
	composer install --no-interaction
	cd /srv/www/videoseo/htdocs/


	# **
	# Installing Developer Plugins from WP.org
	# **

	printf 'Installing Developer Plugins...\n'
	wp plugin install debug-bar  --activate --allow-root
	wp plugin install debug-bar-actions-and-filters-addon  --activate --allow-root
	wp plugin install debug-bar-console --allow-root
	wp plugin install debug-bar-constants --allow-root
	wp plugin install debug-bar-cron  --activate --allow-root
	wp plugin install debug-bar-extender  --activate --allow-root
	wp plugin install debug-bar-list-dependencies --allow-root
	wp plugin install tdd-debug-bar-post-meta --allow-root
	wp plugin install debug-bar-plugin-activation  --activate --allow-root
	wp plugin install debug-bar-post-types  --allow-root
	wp plugin install debug-bar-query-count-alert --allow-root
	wp plugin install debug-bar-query-tracer --allow-root
	wp plugin install debug-bar-remote-requests  --activate --allow-root
	wp plugin install fg-debug-bar-rewrite-rules  --activate --allow-root
	wp plugin install debug-bar-roles-and-capabilities --allow-root
	wp plugin install debug-bar-screen-info --allow-root
	wp plugin install debug-bar-shortcodes --activate --allow-root
	wp plugin install debug-bar-sidebars-widgets --allow-root
	wp plugin install debug-bar-slow-actions --allow-root
	wp plugin install debug-bar-super-globals --allow-root
	wp plugin install debug-bar-taxonomies  --allow-root
	#wp plugin install debug-bar-template-trace --allow-root # No longer in WP repo... ?
	wp plugin install debug-bar-transients --allow-root
	wp plugin install heartbeat-control --allow-root
	wp plugin install pmc-benchmark --allow-root
	wp plugin install demo-data-creator  --activate --allow-root
	wp plugin install developer --allow-root
	wp plugin install kint-debugger --allow-root
	wp plugin install log-deprecated-notices  --activate --allow-root
	wp plugin install log-deprecated-notices-extender  --activate --allow-root
	wp plugin install log-viewer  --activate --allow-root
	wp plugin install p3-profiler --allow-root
	wp plugin install piglatin --allow-root
	wp plugin install rewrite-rules-inspector --allow-root
	wp plugin install rtl-tester --allow-root
	wp plugin install sf-adminbar-tools --allow-root
	wp plugin install simply-show-ids --allow-root
	wp plugin install vip-scanner --allow-root
	wp plugin install what-the-file --allow-root
	wp plugin install whats-running --allow-root
	wp plugin install user-switching --allow-root
	wp plugin install wordpress-beta-tester --allow-root
	wp plugin install wordpress-database-reset --allow-root


	# **
	# Installing Plugins which VideoSEO intends to support from WP.org
	# **

	printf 'Installing VideoSEO supported plugins...\n'
	wp plugin install advanced-responsive-video-embedder --allow-root
	wp plugin install embedplus-for-wordpress --allow-root
	wp plugin install video-playlist-and-gallery-plugin --allow-root
	wp plugin install flowplayer5 --allow-root
	wp plugin install jetpack --allow-root
	wp plugin install sublimevideo-official --allow-root
	wp plugin install tubepress --allow-root
	wp plugin install videojs-html5-video-player-for-wordpress --allow-root
	wp plugin install youtube-embed --allow-root
	wp plugin install vzaar-official-plugin --allow-root
	wp plugin install wp-video-lightbox --allow-root
	wp plugin install wp-youtube-lyte --allow-root
	wp plugin install youtube-embed-plus --allow-root
	wp plugin install youtube-white-label-shortcode --allow-root
	wp plugin install player --allow-root
	wp plugin install featured-video-plus --allow-root
	wp plugin install automatic-youtube-video-posts --allow-root
	wp plugin install iframe-embed-for-youtube --allow-root
	wp plugin install kiss-youtube --allow-root
	wp plugin install media-element-html5-video-and-audio-player --allow-root
	wp plugin install simple-video-embedder --allow-root
	wp plugin install smart-youtube --allow-root
	wp plugin install vippy --allow-root
	wp plugin install vzaar-media-management --allow-root
	wp plugin install wordpress-video-plugin --allow-root
	wp plugin install wp-youtube-player --allow-root
	wp plugin install youtuber --allow-root
	wp plugin install youtube-insert-me --allow-root
	wp plugin install youtube-shortcode --allow-root
	wp plugin install youtube-with-style --allow-root

	# **
	# Cloning some Plugins from Git
	#
	# Download via wp.org has preference, but is not always available.
	# **

	cd /srv/www/videoseo/htdocs/wp-content/plugins

	- git clone -b master --depth=1 https://github.com/foliovision/fv-wordpress-flowplayer.git /tmp/wordpress/src/wp-content/plugins/fv-wordpress-flowplayer
	- git clone -b master --depth=1 https://github.com/wp-plugins/jw-player-plugin-for-wordpress /tmp/wordpress/src/wp-content/plugins/jw-player-plugin-for-wordpress
	- git clone -b master --depth=1 https://github.com/Viper007Bond/vipers-video-quicktags.git /tmp/wordpress/src/wp-content/plugins/vipers-video-quicktags

	cd /srv/www/videoseo/


	# **
	# Supported but not found ?
	#
	# premise
	# weaver
	# vidembed
	*/


else

	cd htdocs/

	# Updates
	if $(wp core is-installed --allow-root); then

		# Update WordPress.
		printf "Updating WordPress for VideoSEO dev environment...\n"
		wp core update --allow-root
		wp core update-db --allow-root

		# Update VideoSEO Supported Plugins from Git
		printf "Updating supported plugins from Git...\n"

		cd /srv/www/videoseo/htdocs/wp-content/plugins/fv-wordpress-flowplayer
		if [[ $(git rev-parse --abbrev-ref HEAD) == 'master' ]]; then
			echo -e "\nUpdating FV WordPress Flowplayer plugin..."
			git pull --ff-only origin master
		else
			echo -e "\nSkipped updating FV WordPress Flowplayer Plugin since not on master branch"
		fi

		cd /srv/www/videoseo/htdocs/wp-content/plugins/jw-player-plugin-for-wordpress
		if [[ $(git rev-parse --abbrev-ref HEAD) == 'master' ]]; then
			echo -e "\nUpdating JW Player for WordPress plugin..."
			git pull --ff-only origin master
		else
			echo -e "\nSkipped updating JW Player for WordPress Plugin since not on master branch"
		fi

		cd /srv/www/videoseo/htdocs/wp-content/plugins/vipers-video-quicktags
		if [[ $(git rev-parse --abbrev-ref HEAD) == 'master' ]]; then
			echo -e "\nUpdating Vipers Video Quicktags plugin..."
			git pull --ff-only origin master
		else
			echo -e "\nSkipped updating Vipers Video Quicktags since not on master branch"
		fi

		cd /srv/www/videoseo/htdocs

		# Update Developer Plugins from WP.org
		printf "Updating Developer Plugins and supported plugins which need updating from WP.org...\n"
		# DON'T update the git repos from WP.org!
		wp plugin update --all --allow-root

	fi

	cd ..

fi

printf "Finished Setup for VideoSEO Dev environment!\n"