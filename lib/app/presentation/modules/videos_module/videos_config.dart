var customSettings = '''
    (function() {
      // Eliminar cualquier estilo previo para evitar duplicados
      var oldStyle = document.getElementById('youtube-custom-style');
      if (oldStyle) {
        oldStyle.parentNode.removeChild(oldStyle);
      }
      
      // Crear un nuevo estilo con ID para poder referenciarlo después
      var style = document.createElement('style');
      style.id = 'youtube-custom-style';
      style.textContent = `
        /* Ocultar logo de YouTube y otros elementos de la UI */
        .ytp-chrome-top,
        .ytp-chrome-bottom,
        .ytp-watermark,
        .ytp-youtube-button,
        .ytp-embed-title,
        .ytp-impression-link,
        .ytp-pause-overlay,
        .ytp-gradient-top,
        .ytp-gradient-bottom,
        .ytp-spinner,
        .ytp-thumbnail-overlay,
        .ytp-large-play-button,
        .ytp-mute-button,
        .ytp-volume-panel,
        .ytp-volume-slider-handle,
        .ytp-scrubber-container,
        .ytp-progress-bar-container,
        .ytp-time-display,
        .ytp-chapter-container,
        .ytp-menuitem,
        .ytp-ce-element,
        .ytp-ce-video,
        .ytp-ce-element-shadow,
        .ytp-watch-later-button,
        .ytp-share-button,
        .ytp-subtitles-button,
        .ytp-settings-button,
        .ytp-playlist-menu-button,
        .ytp-autonav-endscreen-countdown-container {
          display: none !important;
          opacity: 0 !important;
          pointer-events: none !important;
          visibility: hidden !important;
        }
        
        /* Configuración para que todo ocupe el 100% del espacio */
        iframe, 
        body, 
        html, 
        #player, 
        .html5-video-player, 
        .html5-video-container,
        video {
          width: 100% !important;
          height: 100% !important;
          margin: 0 !important;
          padding: 0 !important;
          overflow: hidden !important;
          object-fit: cover !important;
          background-color: black !important;
        }
        
        /* Forzar el video a ocupar todo el espacio disponible */
        video {
          position: absolute !important;
          top: 0 !important;
          left: 0 !important;
          right: 0 !important;
          bottom: 0 !important;
          object-fit: fill !important;
          min-width: 100% !important;
          min-height: 100% !important;
          transform: none !important;
        }
        
        /* Evitar barras de desplazamiento */
        ::-webkit-scrollbar {
          display: none !important;
          width: 0 !important;
          height: 0 !important;
        }
      `;
      
      document.head.appendChild(style);
      
      // Ajustar manualmente el tamaño de todos los elementos relevantes
      function resizeElements() {
        // Obtener todos los contenedores y elementos relevantes
        const containers = [
          document.querySelector('.html5-video-container'),
          document.querySelector('.html5-video-player'),
          document.querySelector('#player'),
          document.querySelector('video')
        ];
        
        // Establecer tamaño al 100% para cada elemento
        containers.forEach(element => {
          if (element) {
            element.style.width = '100%';
            element.style.height = '100%';
            element.style.position = 'absolute';
            element.style.top = '0';
            element.style.left = '0';
            element.style.objectFit = 'fill';
          }
        });
        
        // Establecer específicamente para el video
        const video = document.querySelector('video');
        if (video) {
          video.muted = false;
          video.style.objectFit = 'fill';
          
          // Detectar si el video está cerca del final
          if (video.duration && video.currentTime && (video.duration - video.currentTime < 1)) {
            window.chrome.webview.postMessage('VIDEO_ALMOST_ENDED');
          }
        }
      }
      
      // Ejecutar ahora y periódicamente
      resizeElements();
      setInterval(resizeElements, 1000);
      
      // Añadir evento para detectar fin del video
      const video = document.querySelector('video');
      if (video) {
        // Limpiar eventos previos
        video.removeEventListener('ended', window._videoEndedHandler);
        
        // Crear nuevo manejador
        window._videoEndedHandler = function() {
          window.chrome.webview.postMessage('VIDEO_ENDED');
        };
        
        // Añadir evento
        video.addEventListener('ended', window._videoEndedHandler);
      }
      
      // Prevenir cualquier interacción
      document.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        return false;
      }, true);
      
      // Prevenir menú contextual
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        return false;
      }, true);
    })();
  ''';

var youtubeStyle = '''
        (function() {
          // Crear estilos de preparación
          var prepStyle = document.createElement('style');
          prepStyle.id = 'youtube-prep-style';
          prepStyle.textContent = `
            body, html, * {
              background-color: black !important;
              margin: 0 !important;
              padding: 0 !important;
              overflow: hidden !important;
            }
          `;
          document.head.appendChild(prepStyle);
        })();
      ''';

var videoReady = '''
        (function() {
          var video = document.querySelector('video');
          if (video) {
            video.muted = false;
            video.play();
            window.chrome.webview.postMessage('VIDEO_READY');
          } else {
            window.chrome.webview.postMessage('VIDEO_NOT_READY');
          }
        })();
      ''';

var videoCurrentTime = '''
        (function() {
          var video = document.querySelector('video');
          return video ? Math.floor(video.currentTime) : 0;
        })();
      ''';

var videoPause = '''
        (function() {
          var video = document.querySelector('video');
          if (video) {
            // Pausar el video
            video.pause();
            
            // Enviar información sobre la posición actual
            window.chrome.webview.postMessage(JSON.stringify({
              'event': 'VIDEO_PAUSED',
              'currentTime': video.currentTime,
              'duration': video.duration
            }));
          }
        })();
        ''';

var videoResume = '''
        (function() {
          var video = document.querySelector('video');
          if (video) {
            video.play();
            window.chrome.webview.postMessage('VIDEO_RESUMED');
          }
        })();
        ''';

var videoControls = 'controls=0&' // Sin controles de reproducción
    'autoplay=1&' // Inicia automáticamente
    'mute=0&' // Video silenciado
    'rel=0&' // Sin videos relacionados
    'showinfo=0&' // Sin información del video
    'modestbranding=1&' // Mínimo branding de YouTube
    'iv_load_policy=3&' // Sin anotaciones
    'disablekb=1&' // Deshabilita controles de teclado
    'fs=0&' // Deshabilita botón de pantalla completa
    'playsinline=1&' // Reproducir dentro del elemento
    'enablejsapi=1'; // Habilita JavaScript API