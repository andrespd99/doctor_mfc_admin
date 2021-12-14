import 'package:doctor_mfc_admin/models/system.dart';

import 'package:uuid/uuid.dart';

class DBTest {
  Uuid uuid = Uuid();

  List<System> systems = [];

  DBTest() {
    systemsMap.forEach((systemMap) {
      systems.add(System.fromMap(
        id: systemMap['id'],
        data: systemMap,
      ));
      print('piripiriii');
    });
  }

  late List<Map<String, dynamic>> systemsMap = [
    {
      "id": "${uuid.v4()}",
      "description": "Pick Station",
      "brand": "KNAPP",
      "type": 'general',
      "components": [
        {
          "id": "${uuid.v4()}",
          "description": "Tote",
          "problems": [
            {
              "id": "${uuid.v4()}",
              "description": "Source totes not entering pick station",
              "question": "Is the pick station receiving totes?",
              "keywords": ["", "keyword2", "keyword3"],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "Yes",
                  "isOkResponse": true
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "No",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Set pick station to 'picking mode'",
                      "instructions":
                          "Explain how to set pick station to 'picking mode'",
                      "links": [
                        {
                          "description":
                              "How to set pick station to 'picking mode'",
                          "url": "https://www.google.com",
                        },
                        {
                          "description": "Reset pick station",
                          "url": "https://www.google.com",
                        }
                      ]
                    },
                    {
                      "id": "${uuid.v4()}",
                      "description": "Check if tote is in the sequence",
                      "instructions":
                          "The load unit may have been physically removed and cannot be located by the system. Check if it is in the sequence."
                    },
                    {
                      "id": "${uuid.v4()}",
                      "description":
                          "Check if sensor is blocked on the infeed lane to the pick station",
                      "instructions":
                          "Explain how to check if sensor is blocked on the infeed lane to the pick station"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "id": "${uuid.v4()}",
      "description": "OSR Lift",
      "brand": "KNAPP",
      "type": 'osr',
      "components": [
        {
          "id": "${uuid.v4()}",
          "description": "Gap sensor",
          "problems": [
            {
              "id": "${uuid.v4()}",
              "description": "Gap Sensor at buffer blocked",
              "question": "Is the Gap Sensor at buffer blocked?",
              "keywords": ["rack line", "stuck", "problem"],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "No",
                  "isOkResponse": true
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "Yes",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Unblock gap sensor",
                      "instructions": "",
                      "steps": [
                        {
                          "description":
                              "Enter the OSR from the front using the correct Rack line access procedure.",
                          "substeps": []
                        },
                        {
                          "description":
                              "Locate the buffer in fault and check to see that the sensor which crosses parallel with the lift is clear.",
                          "substeps": [
                            "If there is a skewed tote, place it on the centre of the lift (tote must not cover the outer sensors on the lift)",
                            "If it is clear, make sure that both blue and orange lights, on the sensor, are illuminated. It may need to be aligned with the reflector opposite."
                          ]
                        },
                        {
                          "description":
                              "Exit the OSR and make sure that the lift is activated.",
                          "substeps": []
                        }
                      ],
                      "links": [
                        {
                          "description": "How to enter the OSR",
                          "url": "https://www.google.com",
                        },
                        {
                          "description": "How to exit the OSR",
                          "url": "https://www.google.com",
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "id": "${uuid.v4()}",
      "description": "Open Shuttles",
      "brand": "KNAPP",
      "type": "general",
      "components": [
        {
          "id": "${uuid.v4()}",
          "description": "Open Shuttle",
          "problems": [
            {
              "id": "${uuid.v4()}",
              "description":
                  "Open Shuttle will not GET from transfer lanes or PUT to dispatch ramp whilst error is apparent.",
              "question": "Does the shuttle fails on movement?",
              "keywords": [
                "moving",
                "problem",
                "shuttle",
                "red light",
                "motion"
              ],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "Yes",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Follow the Switch OFF/ON procedure",
                      "steps": [
                        {
                          "description": "Switching OFF",
                          "substeps": [
                            "Locate the 'System Off' (Black) button on the lower left-hand side of the Shuttle.",
                            "Press 'System OFF' for 2 seconds. The LEDs on the shuttle will start to flash RED to signal that the navigation computer is shutting down. When all light signals on the vehicle go out, it is completely switched off. This can take up to 1 minute."
                          ]
                        },
                        {
                          "description": "Switching ON",
                          "substeps": [
                            "Locate the 'System ON' (White) button on the lower left-hand side of the Shuttle.",
                            "Press 'System ON' for 2 seconds. The start-up procedure activates, during this time the vehicle starts its control system and then the navigation computer. These processes are displayed using different light patterns.",
                            "For the Open Shuttle to resume Automatic functions, set the 'Automatic Control Mode' from the Incubed IT Software."
                          ]
                        },
                        {
                          "description":
                              "Log issue using the link bellow. Try uploading a photo to help KNAPP team in the investigation of the issue.",
                          "substeps": []
                        }
                      ],
                      "links": [
                        {
                          "description": "Issue tracking form",
                          "url":
                              "https://www.knapp.com/support/issue-tracking-form"
                        }
                      ]
                    },
                    {
                      "id": "${uuid.v4()}",
                      "description": "solution2",
                      "instructions": "instructions2"
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "No",
                  "isOkResponse": true
                }
              ]
            },
            {
              "id": "${uuid.v4()}",
              "description":
                  "Error resolves in some instances and continues operation but other times the Open Shuttle will need to be restarted to resolve the issue.",
              "related_problems": ["Error during move LHD"],
              "question": "Does the shuttle fails on movement?",
              "keywords": [
                "moving",
                "problem",
                "shuttle",
                "red light",
                "motion"
              ],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "Yes",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Follow the Switch OFF/ON procedure",
                      "steps": [
                        {
                          "description": "Switching OFF",
                          "substeps": [
                            "Locate the 'System Off' (Black) button on the lower left-hand side of the Shuttle.",
                            "Press 'System OFF' for 2 seconds. The LEDs on the shuttle will start to flash RED to signal that the navigation computer is shutting down. When all light signals on the vehicle go out, it is completely switched off. This can take up to 1 minute."
                          ]
                        },
                        {
                          "description": "Switching ON",
                          "substeps": [
                            "Locate the 'System ON' (White) button on the lower left-hand side of the Shuttle.",
                            "Press 'System ON' for 2 seconds. The start-up procedure activates, during this time the vehicle starts its control system and then the navigation computer. These processes are displayed using different light patterns.",
                            "For the Open Shuttle to resume Automatic functions, set the 'Automatic Control Mode' from the Incubed IT Software."
                          ]
                        },
                        {
                          "description":
                              "Log issue using the link bellow. Try uploading a photo to help KNAPP team in the investigation of the issue.",
                          "substeps": []
                        }
                      ],
                      "links": [
                        {
                          "description": "Issue tracking form",
                          "url":
                              "https://www.knapp.com/support/issue-tracking-form"
                        }
                      ]
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "No",
                  "isOkResponse": true
                }
              ]
            },
            {
              "id": "${uuid.v4()}",
              "description": "Route planning issue - Traffic Jam",
              "symptons": [],
              "question": "Are shuttles standstill but not idle?",
              "keywords": ["stuck shuttle", "standstill", "frozen", "motion"],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "Yes",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Follow the Switch OFF/ON procedure",
                      "steps": [
                        {
                          "description":
                              "Go to the Incubed software to investigate the standstill",
                          "substeps": [
                            "Determine which shuttle needs to complete a  priority task (eg. deliver target totes to dispatch ramp)."
                          ]
                        },
                        {
                          "description":
                              "Once determined, manually move the obstructing shuttle clear of the priority shuttle.",
                          "substeps": []
                        },
                        {
                          "description":
                              "Wait until the priority shuttle has passed through to complete its task then re-enable manually moved shuttle",
                          "substeps": []
                        }
                      ],
                      "links": [
                        {
                          "description": "Manually move shuttle",
                          "url": "https://www.linktomanuallymoveshuttle.com"
                        }
                      ]
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "No",
                  "isOkResponse": true
                }
              ]
            },
            {
              "id": "${uuid.v4()}",
              "description": "Open shuttle in Error Position",
              "symptons": ["LEDs flash Yellow ", "Retainers are down"],
              "question": "Is the Shuttle in Error Position?",
              "keywords": [
                "yellow lights",
                "stuck",
                "shuttle",
                "motion",
                "LEDs flash Yellow ",
                "Retainers are down"
              ],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "Yes",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Remove affected totes",
                      "steps": [
                        {
                          "description":
                              "Remove the first tote and take it to a Kisoft station to check the order destination.",
                          "substeps": [
                            "If the Open Shuttle does not change state to deliver the second tote, the second tote will also need to be removed.",
                            "Once all affected totes are removed the Open Shuttle will resume workload automatically."
                          ]
                        }
                      ]
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "No",
                  "isOkResponse": true
                }
              ]
            },
            {
              "id": "${uuid.v4()}",
              "description": "Shuttle erratic movement",
              "question":
                  "Is the Shuttle suddenly stopping or slowing erratically?",
              "keywords": ["erratic shuttle", "stopped", "slow"],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "Yes",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Clean scanner lens",
                      "instructions":
                          "Using compressed air or similar (Blower) try to remove any dust/debris from the lens of the scanner. (BE CAREFUL TO NOT SCRATCH THE LENS)\n\nIf possible, using a clean microfibre cloth, wipe the lens to remove any excess grime."
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "No",
                  "isOkResponse": true
                }
              ]
            },
            {
              "id": "${uuid.v4()}",
              "description": "Error on Incubed Software",
              "question": "Do you have an error on Incubed Software?",
              "keywords": ["erratic shuttle", "stopped", "slow"],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "Yes",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Clean scanner lens",
                      "instructions":
                          "Using compressed air or similar (Blower) try to remove any dust/debris from the lens of the scanner. (BE CAREFUL TO NOT SCRATCH THE LENS)\n\nIf possible, using a clean microfibre cloth, wipe the lens to remove any excess grime."
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "No",
                  "isOkResponse": true
                }
              ]
            },
            {
              "id": "${uuid.v4()}",
              "description": "Emergency Stop Pressed",
              "question": "Was the emergency stop pressed?",
              "keywords": ["emergency stop"],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "Yes",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Safe restart",
                      "steps": [
                        {
                          "description":
                              "Determine and, if necessary, rectify the cause of the emergency stop.",
                          "substeps": []
                        },
                        {
                          "description":
                              "Check whether a safe restart is possible.",
                          "substeps": []
                        },
                        {
                          "description":
                              "Deactivate emergency stop button (Refer Fig, Item #1).",
                          "substeps": [
                            "The blue acknowledgement button flashes (Refer Fig, Item #2)."
                          ]
                        },
                        {
                          "description":
                              "Press the acknowledgement button, when:",
                          "substeps": [
                            "The acknowledgement button goes dark",
                            "All LED indicators light up green",
                            "The power supply of the drive motors is re-established",
                            "Brakes are released An audible start signal sounds",
                            "Open Shuttle starts moving again"
                          ]
                        }
                      ]
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "No",
                  "isOkResponse": true
                }
              ]
            },
            {
              "id": "${uuid.v4()}",
              "description":
                  "Sensor/light barrier Misaligned / Error on Shuttle",
              "question": "What is the sensor's light status?",
              "keywords": [
                "disaligned",
                "sensor",
                "light barrier",
                "reflectors",
                "led"
              ],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "Solid green and blinking orange",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Align sensor to the reflector",
                      "instructions":
                          "Align sensor to the reflector. Blinking signifies that the sensor beam is on the very edge of the reflector. \n\nIf you can't adjust sensor without the aid of tools, finish troubleshoot and contact the onsite technician to assist you."
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "Solid green but no orange light visible",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Unload Open Shuttle",
                      "instructions":
                          "Unload Open Shuttle, then check loading status. If loading status is not correct, restart Open Shuttle.",
                      "links": [
                        {
                          "description": "How to restart Open Shuttle",
                          "url": "https://www.linktorestartopenshuttle.com"
                        }
                      ]
                    },
                    {
                      "id": "${uuid.v4()}",
                      "description": "Align sensor to the reflector",
                      "steps": [
                        {
                          "description":
                              "Align sensor to the reflector. Blinking signifies that the sensor beam is on the very edge of the reflector.",
                          "substeps": []
                        },
                        {
                          "description":
                              "If you can't adjust sensor without the aid of tools, finish troubleshoot and contact the onsite technician to assist you.",
                          "substeps": []
                        },
                        {
                          "description":
                              "Check the Incubed software to determine if the loading status is correct (loaded or empty Shuttle).",
                          "substeps": [
                            "If the status is not correct – Restart the Open Shuttle."
                          ]
                        }
                      ],
                      "links": [
                        {
                          "description": "How to restart Open Shuttle",
                          "url": "https://www.linktorestartopenshuttle.com"
                        }
                      ]
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "Red",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Follow the Switch OFF/ON procedure",
                      "steps": [
                        {
                          "description": "Switching OFF",
                          "substeps": [
                            "Locate the 'System Off' (Black) button on the lower left-hand side of the Shuttle.",
                            "Press 'System OFF' for 2 seconds. The LEDs on the shuttle will start to flash RED to signal that the navigation computer is shutting down. When all light signals on the vehicle go out, it is completely switched off. This can take up to 1 minute."
                          ]
                        },
                        {
                          "description": "Switching ON",
                          "substeps": [
                            "Locate the 'System ON' (White) button on the lower left-hand side of the Shuttle.",
                            "Press 'System ON' for 2 seconds. The start-up procedure activates, during this time the vehicle starts its control system and then the navigation computer. These processes are displayed using different light patterns.",
                            "For the Open Shuttle to resume Automatic functions, set the 'Automatic Control Mode' from the Incubed IT Software."
                          ]
                        },
                        {
                          "description":
                              "Log issue using the link bellow. Try uploading a photo to help KNAPP team in the investigation of the issue.",
                          "substeps": []
                        }
                      ],
                      "links": [
                        {
                          "description": "Issue tracking form",
                          "url":
                              "https://www.knapp.com/support/issue-tracking-form"
                        }
                      ]
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "Solid green and orange",
                  "isOkResponse": true
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "id": "${uuid.v4()}",
      "description": "Conveyor Lane",
      "brand": "KNAPP",
      "type": "general",
      "components": [
        {
          "id": "${uuid.v4()}",
          "description": "Transfer lane",
          "problems": [
            {
              "id": "${uuid.v4()}",
              "description": "Stopper down",
              "question": "Is the stopper down?",
              "keywords": ["transfer lane"],
              "userResponses": [
                {
                  "id": "${uuid.v4()}",
                  "description": "Yes",
                  "isOkResponse": false,
                  "solutions": [
                    {
                      "id": "${uuid.v4()}",
                      "description": "Create ticket for help",
                      "steps": [
                        {
                          "description":
                              "Lock the transfer lane which is impacted, using the Incubed software. This is to prevent target totes from being assigned to the lane.",
                          "substeps": []
                        },
                        {
                          "description":
                              "Log a Zendesk ticket with a priority 3, ask for KNAPP to reset the Open Shuttle server and SRC for the impacted lane.",
                          "substeps": []
                        },
                        {
                          "description":
                              "Wait for a 'RECOVERED' response from the KNAPP Service desk, via email, and inspect the impacted lane for recovery confirmation",
                          "substeps": [
                            "If not recovered, update the Zendesk ticket to reflect the situation"
                          ]
                        },
                        {
                          "description":
                              "Update the Zendesk ticket with information on lane recovery",
                          "substeps": []
                        },
                        {
                          "description": "Unlock lane using Incubed software",
                          "substeps": [
                            "If totes do not start entering the lane, update the Zendesk ticket to refect"
                          ]
                        }
                      ]
                    }
                  ]
                },
                {
                  "id": "${uuid.v4()}",
                  "description": "No",
                  "isOkResponse": true
                }
              ]
            }
          ]
        },
      ]
    }
  ];
}
