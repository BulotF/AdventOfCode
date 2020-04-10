<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:param name="depth-file"/>
    <xsl:variable name="depth-chemical" select="doc($depth-file)"/>
    
    <xd:doc>
        <xd:desc>template qui initialise l'appel au template nommé calculate-chemical avec 1 FUEL et rien d'autre à produire ; profondeur initiale : 1</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:call-template name="calculate-chemical">
            <xsl:with-param name="depth" select="1"/>
            <xsl:with-param name="chemicals" as="node()">
                <chemicals>
                    <chemical output="ORE" inquantity="0"/>
                    <xsl:for-each select="/chemicals/chemical">
                        <xsl:copy>
                            <xsl:choose>
                                <xsl:when test="@output='FUEL'">
                                    <xsl:attribute name="inquantity" select="1"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="inquantity" select="0"/>        
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:copy-of select="@* | node()"/>
                        </xsl:copy>
                    </xsl:for-each>
                </chemicals>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>template nommé récursif qui remplace tous les produits chimiques de profondeur $depth par leurs réactifs,
            puis appelle le même template pour la profondeur $depth +1</xd:desc>
    </xd:doc>
    <xsl:template name="calculate-chemical">
        <xsl:param name="chemicals" as="node()"/>
        <xsl:param name="depth"/>
        
        <xsl:choose>
            <!-- S'il existe un composé chimique à produire -->
            <xsl:when test="$depth-chemical//chemical[($depth=1 and @depth='') or ($depth!=1 and @depth=string($depth))]">
                <!-- xsl:message permet de laisser des traces dans les logs -->
                <!--<xsl:message select="$depth"/>
                <xsl:message select="$chemicals"/>-->
                <!-- on liste les composés chimiques à produire -->
                <xsl:variable name="reactions" select="$depth-chemical//chemical[($depth=1 and @depth='') or ($depth!=1 and @depth=string($depth))]/@name" as="xs:string*"/>
                <!-- on calcule le nombre de réactifs présents avant les réactions de profondeur $depth -->
                <xsl:variable name="new-chemical" as="node()">
                    <chemicals>
                        <!-- pour chaque composé chimique (enfant de chemicals pour éviter les doublons) -->
                        <xsl:for-each select="$chemicals//chemical[parent::chemicals]">
                            <xsl:variable name="name" select="@output"/>
                            <xsl:choose>
                                <!-- On supprime les composés produits -->
                                <xsl:when test="$name = $reactions"/>
                                <xsl:otherwise>
                                    <chemical>
                                        <xsl:attribute name="output" select="$name"/>
                                        <xsl:attribute name="outquantity" select="@outquantity"/>
                                        <!-- On remplace les quantités des composés pérennes -->
                                        <!-- On ajoute leur ancienne quantité et les quantités en tant que réactifs des réactions de profondeur $depth -->
                                        <!-- on produit au moins le nombre de produits nécessaires ; 
                                            éventuellement un peu plus si la réaction génère un nombre de produits qui n'est pas un diviseur de la quantité nécessaire -->
                                        <!-- noter que la division se fait avec la formule a div b car le / est déjà utilisé pour la navigation -->
                                        <!-- On peut adapter l'identation par défaut pour rendre la formule plus compréhensible par l'équipe de maintenance -->
                                        <xsl:attribute name="inquantity" select="@inquantity 
                                            + sum($chemicals//chemical[@output=$reactions]/chemical[@input=$name]/(@inquantity 
                                                                                                                 * ceiling((parent::chemical/@inquantity) 
                                                                                                                       div (parent::chemical/@outquantity)))
                                                 )"/>
                                        <xsl:copy-of select="chemical"/>
                                    </chemical>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </chemicals>
                </xsl:variable>
<!--                <xsl:message select="$new-chemical"/>-->
                <xsl:call-template name="calculate-chemical">
                    <xsl:with-param name="chemicals" as="node()" select="$new-chemical"/>
                    <xsl:with-param name="depth" select="$depth +1"/>
                </xsl:call-template>
            </xsl:when>
            <!-- Si tous les produits chimiques ont été transformés, on renvoie le résultat -->
            <xsl:otherwise>
                <xsl:copy-of select="$chemicals"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>