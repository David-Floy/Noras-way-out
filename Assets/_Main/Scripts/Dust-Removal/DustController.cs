using UnityEngine;
using UnityEngine.InputSystem;

public class DustController : MonoBehaviour
{
    public Material dustMaterial; // Dein Dust-Material
    private float dustAmount = 1.0f; // Anfangswert für Staub

    void Update()
    {
        if (Keyboard.current.spaceKey.isPressed) // Zum Testen: Staub verringern mit Leertaste
        {
            RemoveDust();
        }
    }

    public void RemoveDust()
    {
        dustAmount = Mathf.Max(0, dustAmount - Time.deltaTime * 0.5f); // Reduziert Staub schrittweise
        dustMaterial.SetFloat("_DustAmount", dustAmount);
    }
}

