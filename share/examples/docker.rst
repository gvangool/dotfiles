Dockerfile snippets
===================
Set locale
----------
On Debian/Ubuntu

.. code:: Dockerfile

   RUN set -eu \
           && apt-get update \
           && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
           && rm -rf /var/lib/apt/lists/* \
           && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen  \
           && dpkg-reconfigure --frontend=noninteractive locales \
           && update-locale LANG=en_US.UTF-8
   ENV LANG=en_US.UTF-8 LANGUAGE=en_US:en LC_ALL=en_US.UTF-8

Set timezone
------------
.. code:: Dockerfile

  ENV TZ=America/Vancouver
  RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

On Alpine, you have 2 options:

- keep the tzdata package installed (adds 1.33MB)::

    ENV TZ=America/Vancouver
    RUN apk add --no-cache tzdata && \
        ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
        echo $TZ > /etc/timezone

- copy the timezone to localtime (adds 0.03MB)::

    RUN set -eu \
          && TZ=America/Vancouver
          && apk add --no-cache tzdata \
          && cp /usr/share/zoneinfo/$TZ /etc/localtime \
          && echo $TZ > /etc/timezone \
          && apk del tzdata
