<?php

declare(strict_types=1);

/**                                                                                                                              
 * This is needed for cookie based authentication to encrypt password in                                                         
 * cookie. Needs to be 32 chars long.                                                                                            
 */
$cfg['blowfish_secret'] = 'n;lmCKZxhSJMn3ST/n1DGVYgDxS-w14D';

/* Servers configuration */
$i = 1;

/* Authentication type */
$cfg['Servers'][$i]['auth_type'] = 'cookie';
/* Server parameters */
$cfg['Servers'][$i]['host'] = '$DB_HOST';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = false;

$cfg['Servers'][$i]['user'] = '$DB_USER';
$cfg['Servers'][$i]['password'] = '$DB_PASS';

/* Directories for saving/loading files from server */
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';

$cfg['TempDir'] = 'tmp';
