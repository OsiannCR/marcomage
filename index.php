<?php
/**
 * MArcomage - single entry point
 */

try {
    // bootstrap application
    require(__DIR__ . '/src/bootstrap.php');

    // dispatch response
    $response = Dic::dispatch();

    // output response
    $response->output();
}
catch (Exception $e) {
    error_log('MArcomage Fatal error: ' . $e->getMessage());

    // case 1: web entry point
    if (Dic::getMiddlewareName() == 'web') {
        // redirect to fail page
        header('Location: fail.php?error=' . urlencode($e->getMessage()));
    }
    // case 2: default case
    else {
        while (ob_get_level()) {
            ob_end_clean();
        }

        header('HTTP/1.1 500 Internal Server Error');
        echo "Unexpected Error. Sorry, try again later.\n";

        // exit with error status
        exit(1);
    }
}
