# MArcomage

## Introduction

MArcomage (Multiplayer Arcomage) is an online version of the classic fantasy turn-based card game Arcomage, which appears as a minigame in the Might and Magic series of PC games.
This card game simulates an epic battle between two empires including features such as constructing new buildings, training troops and decimating the enemy empire with standard attacks or sneaky tactics such as intrigue or spells.

The project is a PHP web-based application which features a deck builder, player challenging system, various means of communication, and most importantly the actual duel engine.
Players may customize their profile and adjust the interface's appearance. The gameplay itself is turn-based, but contrary to the original it doesn't have to be played in real time.

## Installation

1. checkout GIT repository from `https://github.com/mfendek/marcomage.git`
2. run composer install in project directory
3. run DB install script located in `scripts/install_tables.sql`
4. point your virtual host to project directory

## Configuration

Base config file is located in `src/config.php` and is kept under version control. Production specific config is located in `src/config_production.php`.
This file however is not part of the codebase. Base config file is merged with production config with the latter overriding the former.
Configuration that is not present in the production config is inherited from base config file.
 
 ## Database
 
 This application uses MySQL database to store `instance data` (read and write data) and XML files to store `definition data` (read only).
 Low level database functionality is well separated from the rest of the code. This allows to switch to a completely different database system without too much trouble.
 For example MongoDB support is available. This also applies to XML files which could be for example replaced with JSON files.
 
 ## Architecture
 
 MVC with thin controller approach. Most of the business code is located in the services.
 Application uses top level container (dependency injection) which provides lazy load for all other objects via factory.
 Templates use XSLT as template engine and support two render modes: layout and fragment mode.
 Layout mode is the default one and is used for rendering pages.
 Fragment mode is used for rendering HTML fragments which is usually used for AJAX, but can be used for other purposes like RSS feeds.
 
 Application uses single entry point system (`index.php`). Single entry point determines the correct `Middleware` based on request data.
 `Middleware` acts as a gateway to application, it serves as a wrap for controllers. 
 `Middleware` typically provides common functionality for controllers like session validation
 and response formatting (`HTML`, `JSON` ...).
 
 ## Features
 
 * game lobby (used for management of games)
 * deck builder
 * players ladder
 * player settings allows advanced customization like themes are other UI improvements
 * shop allows players to unlock additional game features like game slots
 * private messages system
 * discussion forum which is integrated with the rest of the site
 * website news and card updates
 * help and FAQ
 * game AI (it's possible to play against a computer opponent as well)
 * challenge AI (a much harder AI that uses it's own custom deck)
 * statistics provide useful information about cards and games
 * game replays database
 * complete card database
 * card suggestions section (this is where users can create their own cards)
 
 ## Maintenance
 
 Maintenance scripts are located in the `Scripts` controller and are accessed via the `Scripts` middleware. 
 Here is an example of the `maintenance url`:
 
 `?m=scripts&name=<script_name>&password=<maintenance_access_password>`
 
 ## Development
 
 Basic code sniffer can be setup via `squizlabs/php_codesniffer` library. It is also recommended to use the `.editorconfig`
 for basic IDE project setup.
 
 ### Backend
 
 Run `composer install` to update backend libraries. In case you want to update existing libraries run `composer update`.
 You need to commit `composer.json` and `composer.lock` files in case they were changed. Never run `composer update` on production.
 
 ### Frontend
 
 Run `yarn install` to update frontend libraries. Run `yarn watch` as a preprocessor watcher and `yarn build` if you want a one time build.
 Run `yarn package` before committing your changes. In case libraries were updated you need to commit both `package.json` and `yarn.lock` files.
 
 ## Dependency management
 
 Third party libraries should be included via `Composer` or `Yarn`.
 If a library is not available in such form it may be included manually.
 It's important to make sure that such library is separated from the rest of the code by keeping it in a separate directory for example.
 
 ## Production deployment
 
 * run `svn update`
 * run `composer install --no-dev`
 * run maintenance scripts (optional)
 
 ## Coding standards
 
 * PSR-1, PSR-2 (backend)
 * Air BnB, BEM (frontend)
 
 ## Links
 
 * Composer - https://getcomposer.org/
 * Node - https://nodejs.org/
 * Yarn - https://yarnpkg.com/
 * PSR-1 - http://www.php-fig.org/psr/psr-1/
 * PSR-2 - http://www.php-fig.org/psr/psr-2/
 * Air BnB - https://github.com/airbnb/javascript
 * BEM - http://getbem.com/naming/
 * Color Names - http://www.colorhexa.com/
 * Flex box - https://css-tricks.com/snippets/css/a-guide-to-flexbox/
 * Basic code sniffer - https://github.com/squizlabs/PHP_CodeSniffer
 * Advanced code sniffer - https://github.com/slevomat/coding-standard
 * PHP Storm setup - https://confluence.jetbrains.com/display/PhpStorm/PHP+Code+Sniffer+in+PhpStorm#PHPCodeSnifferinPhpStorm-1.EnablePHPCodeSnifferintegrationinPhpStorm
