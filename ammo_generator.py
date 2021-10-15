#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys


def make_ammo(method, host, url, headers, case, token, body):
    """ makes phantom ammo """
    # http request w/o entity body template
    req_template = (
          "%s %s HTTP/1.1\r\n"
          "Host: %s\r\n"
          "%s\r\n"
          "\r\n"
    )

    # http request w/o entity body template & token
    req_template_wo_token = (
          "%s %s HTTP/1.1\r\n"
          "Host: %s\r\n"
          "%s\r\n"
          "\r\n"
    )

    # http request with entity body template
    req_template_w_entity_body = (
          "%s %s HTTP/1.1\r\n"
          "Host: %s\r\n"
          "%s\r\n"
          "%s\r\n"
          "Content-Length: %d\r\n"
          "\r\n"
          "%s\r\n"
    )

    # http request with entity body template
    req_template_w_entity_body_wo_token = (
          "%s %s HTTP/1.1\r\n"
          "Host: %s\r\n"
          "%s\r\n"
          "Content-Length: %d\r\n"
          "\r\n"
          "%s\r\n"
    )

    if not body:
        if not token:
            req = req_template % (method, url, host, headers)
        else:
            req = req_template_wo_token % (method, url, host, headers, token)
    else:
        if not token:
            req = req_template_w_entity_body_wo_token % (method, url, host, headers, len(body), body)
        else:
            req = req_template_w_entity_body % (method, url, host, headers, token, len(body), body)
        
    # phantom ammo template
    ammo_template = (
        "%d %s\n"
        "%s"
    )

    return ammo_template % (len(req), case, req)


def main():
    for stdin_line in sys.stdin:
        try:
            method, host, url, case, token, body = stdin_line.split("||")
            body = body.strip()
        except ValueError:
            method, host, url, case, token = stdin_line.split("||")
            body = None

        method, host, url, case, token = method.strip(), host.strip(), url.strip(), case.strip(), token.strip()

        headers =   "User-Agent: 1C+Enterprise/8.3\r\n" + \
                    "Accept: /\r\n" + \
                    "Content-Type: application/octet-stream"

        sys.stdout.write(make_ammo(method, host, url, headers, case, token, body))


if __name__ == "__main__":
    main()