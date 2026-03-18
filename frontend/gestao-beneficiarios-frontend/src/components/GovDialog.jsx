import React from 'react';
import './GovDialog.css';

const GovDialog = ({
  isOpen,
  title,
  message,
  confirmLabel = 'Confirmar',
  cancelLabel = 'Cancelar',
  showCancel = true,
  variant = 'info',
  onConfirm,
  onCancel,
}) => {
  if (!isOpen) {
    return null;
  }

  const handleOverlayClick = (event) => {
    if (event.target.classList.contains('gov-dialog-overlay') && onCancel) {
      onCancel();
    }
  };

  return (
    <div className="gov-dialog-overlay" onClick={handleOverlayClick} role="presentation">
      <div
        className="gov-dialog"
        role="dialog"
        aria-modal="true"
        aria-labelledby="gov-dialog-title"
      >
        <div className={`gov-dialog-header gov-dialog-header-${variant}`}>
          <h2 id="gov-dialog-title">{title}</h2>
        </div>

        <div className="gov-dialog-body">
          <p>{message}</p>
        </div>

        <div className="gov-dialog-footer">
          {showCancel && (
            <button type="button" className="br-button secondary" onClick={onCancel}>
              {cancelLabel}
            </button>
          )}
          <button
            type="button"
            className={`br-button ${variant === 'danger' ? 'danger' : 'primary'}`}
            onClick={onConfirm}
          >
            {confirmLabel}
          </button>
        </div>
      </div>
    </div>
  );
};

export default GovDialog;

