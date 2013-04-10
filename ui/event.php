<?php

/**
 * Suomen Frisbeeliitto Kisakone
 * Copyright 2009-2010 Kisakone projektiryhm�
 *
 * Event main page -- this contains all the other user-visible pages
 * 
 * --
 *
 * This file is part of Kisakone.
 * Kisakone is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Kisakone is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with Kisakone.  If not, see <http://www.gnu.org/licenses/>.
 * */

/**
 * Initializes the variables and other data necessary for showing the matching template
 * @param Smarty $smarty Reference to the smarty object being initialized
 * @param Error $error If input processor encountered a minor error, it will be present here
 */
function InitializeSmartyVariables(&$smarty, $error) {

    $event = GetEventDetails($_GET['id']);
    $smarty->assign('event', $event);
    global $user;

    if (is_a($event, 'Error'))
        return $event;

    if (!$event)
        return Error::NotFound('event');

    $smarty->assign('eventid', $event->id);

    $textType = '';
    $evp = null;

    if (!isAdmin() && !$event->isTD() && !$event->isActive) {
        $error = new Error();
        $error->isMajor = true;
        $error->title = 'error_event_not_active';
        $error->description = translate('error_event_not_active_description');
        $error->source = 'PDR:Event:InitializeSmartyVariables';
        return $error;
    }

    switch ((string) @$_GET['view']) {
        case '':

            $view = 'index';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);
            list($ci_html, $ci_js) = page_ObfuscateContactInfo($event->contactInfo);

            $smarty->assign('news', $event->GetNews(0, 5));
            $smarty->assign('contactInfoHTML', $ci_html);
            $smarty->assign('contactInfoJS', $ci_js);
            $smarty->assign('rounds', $event->GetRounds());

            if ($user) {
                $player = $user->GetPlayer();

                if ($player) {
                    $smarty->assign('groups', GetUserGroupSummary($event->id, $player->id));
                }
            }

            // The index page has an extra text content area for schedule, must be taken care
            // of manually
            $scheduleText = $event->GetTextContent('index_schedule');
            $index_schedule_content = '';
            if ($scheduleText) {
                $index_schedule_content = $scheduleText->formattedText;
            }
            $smarty->assign('index_schedule_text', $index_schedule_content);

            break;
        case 'competitors':
            $view = 'competitors';
            language_include('users');
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);
            $participants = $event->GetParticipants(@$_GET['sort'], @$_GET['search']);
            $smarty->assign('participants', $participants);

            break;
        case 'schedule':
            $view = 'schedule';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);
            $smarty->assign('rounds', $event->GetRounds());
            $smarty->assign('allow_print', IsAdmin() || $event->management != '');
            break;
        case 'course':
            $view = 'course';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);
            $smarty->assign('courses', pdr_GetCourses($event));
            break;

        case 'cancelsignup':
            $view = 'cancelsignup';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);
            $smarty->assign('signupOpen', $event->SignupPossible());
            $smarty->assign('paid', $event->eventFeePaid);

            break;
        case 'signupinfo':
            $view = 'signupinfo';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);

            $classes = $event->GetClasses();
            $smarty->assign('classes', $classes);
            $smarty->assign('signedup', $event->approved !== null);
            $smarty->assign('paid', $event->eventFeePaid);
            $smarty->assign('signupOpen', $event->SignupPossible());
            //$smarty->assign('openPositions', $event->getOpenPositions($classes));
            $requiredFees = $event->FeesRequired();

            if ($user) {
                $playerId = @$user->GetPlayer()->id;
                if (isset($playerId)) {


                    $canSignup = $event->IsSignuppable($playerId);
                    if (!$canSignup) {
                        $smarty->assign('allreadyOnWaitinlist', true);
                    }
                }
            }
            if ($requiredFees && $user) {
                if ($message = $user->FeesPaidForYear(date('Y', $event->startdate), $requiredFees)) {
                    $smarty->assign('feesMissing', $message);
                }
            }


            break;
        case 'payment':
            $view = 'payment';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);


            $smarty->assign('classes', $event->GetClasses());
            $smarty->assign('signedup', $event->approved !== null);
            $smarty->assign('paid', $event->eventFeePaid);
            $smarty->assign('signupOpen', $event->SignupPossible());
            break;
        case 'newsarchive':
            $view = 'newsarchive';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);

            $smarty->assign('news', $event->GetNews(0, 9999));

            break;
        case 'results':
        case 'liveresults':
            $view = 'results';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);




            $rounds = $event->GetRounds();
            $smarty->assign('classes', $event->GetClasses());


            $smarty->assign('rounds', $rounds);
            $roundnum = @$_GET['round'];
            if (!$roundnum)
                $roundnum = 1;

            $roundid = @$rounds[$roundnum - 1]->id;
            $theround = @$rounds[$roundnum - 1];
            if ($theround) {


                $smarty->assign('the_round', $theround);

                $r = $theround->GetFullResults('resultsByClass');
                foreach ($r as $k => $v) {
                    $r[$k] = pdr_IncludeStanding($v);
                }


                $smarty->assign('resultsByClass', $r);



                $holes = $theround->GetHoles();
                $smarty->assign('holes', $holes);
                $smarty->assign('out_hole_index', ceil(count($holes) / 2));

                $smarty->assign('live', $_GET['view'] == 'liveresults');

                $smarty->assign('roundid', $roundid);
            }


            break;
        case 'leaderboard':
            $view = 'leaderboard';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);



            $results = pdr_GroupByClasses(GetEventResultsWithoutHoles($event->id));

            $scoresAssigned = null;
            foreach ($results as $class) {
                foreach ($class as $item) {
                    $scoresAssigned = $item['TournamentPoints'] != 0;
                    break;
                }
                break;
            }

            $smarty->assign('includePoints', $scoresAssigned && $event->tournament);
            $smarty->assign('resultsByClass', $results);
            $rounds = $event->GetRounds();
            $smarty->assign('numRounds', count($rounds));
            $smarty->assign('rounds', $rounds);

            break;
        case 'leaderboard_cvs':
            $view = 'leaderboard_cvs';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);



            $results = pdr_GroupByClasses(GetEventResultsWithoutHoles($event->id));

            $scoresAssigned = null;
            foreach ($results as $class) {
                foreach ($class as $item) {
                    $scoresAssigned = $item['TournamentPoints'] != 0;
                    break;
                }
                break;
            }

            $smarty->assign('includePoints', $scoresAssigned && $event->tournament);
            $smarty->assign('resultsByClass', $results);
            $rounds = $event->GetRounds();
            $smarty->assign('numRounds', count($rounds));
            $smarty->assign('rounds', $rounds);

            break;
        case 'waitinglist':
            $view = 'waitinglist';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);

            language_include('users');


            $queryList = $event->GetWaitingQueue(@$_GET['sort'], @$_GET['search']);
            $smarty->assign('participants', $queryList);

            break;
        case 'leaderboard_cvs':
            $view = 'leaderboard_cvs';
            $visibility = checkEventViewVisibility($event->id, $view);
            $smarty->assign('visibility', $visibility);



            $results = pdr_GroupByClasses(GetEventResultsWithoutHoles($event->id));

            $scoresAssigned = null;
            foreach ($results as $class) {
                foreach ($class as $item) {
                    $scoresAssigned = $item['TournamentPoints'] != 0;
                    break;
                }
                break;
            }

            $smarty->assign('includePoints', $scoresAssigned && $event->tournament);
            $smarty->assign('resultsByClass', $results);
            $rounds = $event->GetRounds();
            $smarty->assign('numRounds', count($rounds));
            $smarty->assign('rounds', $rounds);

            break;


        default:


            // If we have a numeric view we are to show a custo m content page
            if (is_numeric(@$_GET['view'])) {
                $evp = $event->GetTextContent(@$_GET['view']);
                $view = 'custom';
            } else {
                $view = 'missing';
            }
            break;
    }

    // Views can override text contnet type, normally it matches the view
    if (!$textType)
        $textType = $view;
    if (!$evp)
        $evp = $event->GetTextContent($textType);


    if (!$evp || is_a($evp, 'Error')) {
        $evp = new TextContent(array());
        $evp->type = $textType;
    }

    if (!$evp->title) {
        $evp->title = translate('pagetitle_' . $textType);
    }

    if (!$evp->content) {
        $evp->content = "<h2>" . htmlentities($evp->title) . "</h2>";
        $evp->FormatText();
    }

    // Event pages have their own ads
    $ad = GetAd($event->id, $view);
    if (!$ad) {
        $ad = GetAd($event->id, 'eventdefault');
    }
    if ($ad)
        $smarty->assign('ad', $ad);
    $smarty->assign('view', 'eventviews/' . $view . '.tpl');
    $smarty->assign('page', $evp);
    $smarty->assign('title', $evp);
    $smarty->assign('textcontent', $evp);
}

/**
 * Determines which main menu option this page falls under.
 * @return String token of the main menu item text.
 */
function getMainMenuSelection() {
    return 'events';
}

/**
 * Provides obfuscated version of contact info, suitable for use on a web page
 * with less risk of bots finding it
 */
function page_ObfuscateContactInfo($contactInfo) {
    return array(
        page_ObfuscateContactInfo_HTML($contactInfo),
        page_ObfuscateContactInfo_JS($contactInfo));
}

/**
 * HTML version; reverse order with relative positioning used to
 * restore the order on-screen; the downside is that browsers can't really
 * select the text either.
 */
function page_ObfuscateContactInfo_HTML($ci) {
    preg_match_all('/(.)/us', $ci, $characters);
    $reversed = array_reverse($characters[0]);
    ob_start();


    $pos = count($reversed) * 0.65;
    foreach ($reversed as $character) {
        echo sprintf('<span style="position: relative; left: %Fem">%s</span>', $pos, $character);
        $pos -= 1.25;
    }
    return ob_get_clean();
}

/**
 * Simple javascript-based string construction
 */
function page_ObfuscateContactInfo_JS($ci) {
    preg_match_all('/(.)/us', $ci, $characters);
    $characters = $characters[0];
    ob_start();

    foreach ($characters as $character) {
        if ($character == "'")
            $character = "\\'";
        else if ($character == "\\")
            $character == "\\\\";
        echo "ci.push('$character');\n";
    }
    return ob_get_clean();
}

function pdr_GetCourses($event) {
    $rounds = $event->GetRounds();
    $courses = array();
    foreach ($rounds as $index => $round) {
        $course = $round->GetCourse();

        if (!$course)
            continue;

        if (is_a($course, 'Error'))
            return $course;
        $cid = $course['id'];
        if (isset($courses[$cid])) {
            $courses[$cid]['Rounds'][] = $index + 1;
            continue;
        } else {
            $course['Rounds'] = array($index + 1);
        }
        $course['Holes'] = $round->GetHoles();
        $courses[$course['id']] = $course;
    }


    foreach ($courses as $id => $course) {
        $rounds = $course['Rounds'];
        if (count($rounds) == 1) {
            $courses[$id]['Rounds'] = translate('round_title', array('number' => $rounds[0]));
        } else {
            $courses[$id]['Rounds'] = translate('many_round_title', array('rounds' => pdr_nice_implode($rounds)));
        }
    }
    //print_r($courses);
    return $courses;
}

/**
 * Groups results by the classes of the players
 */
function pdr_GroupByClasses($data) {
    $out = array();
    foreach ($data as $row) {
        $class = $row['ClassName'];
        if (!isset($out[$class]))
            $out[$class] = array();
        $out[$class][] = $row;
    }

    // Shouldn't really call a function internal to core, but it does the exact thing
    // we need here
    uasort($out, 'core_sort_by_count');

    return $out;
}

/**
 * Combines strings "nicely"; that is, commas between all items, except the last 2
 * which have "and" between them
 */
function pdr_nice_implode($text) {
    $and = translate('and');
    $list = array();
    foreach ($text as $item) {
        $list[] = $item;
        $list[] = ", ";
    }

    if (count($list)) {
        unset($list[count($list) - 1]);
        if (count($list) > 1) {
            $list[count($list) - 2] = " $and ";
        }
    }

    return implode("", $list);
}

/**
 * Adds a standing field to result data
 */
function pdr_IncludeStanding($d) {
    $out = array();
    $lastResult = -999;
    $lastStanding = 0;
    $step = 1;

    foreach ($d as $item) {
        $result = $item['CumulativePlusminus'];

        if ($item['DidNotFinish'])
            $result = 999;

        if ($result == $lastResult) {
            $item['Standing'] = $lastStanding;
            ++$step;
        } else {
            $lastStanding += $step;
            $step = 1;
            $item['Standing'] = $lastStanding;
            $lastResult = $result;
        }


        $out[] = $item;
    }
    //print_r($out);
    return $out;
}

?>
